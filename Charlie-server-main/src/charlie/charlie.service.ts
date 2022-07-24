import { HttpStatus, Injectable } from '@nestjs/common';
import { LogService } from 'src/log/log.service';
import { PrismaService } from 'src/shared/services/prisma.service';

@Injectable()
export class CharlieService {
  constructor(private logService: LogService, private prisma: PrismaService) {}

  async addDecoration(decorationData: any): Promise<any> {
    await this.prisma.decoration.create({
      data: {
        name: decorationData.name,
        type: decorationData.type,
        decorationIndex: decorationData.decorationIndex,
      },
    });
  }

  async createDefaultCharlie(id: string): Promise<any> {
    const baseCharlie = await this.prisma.charlie.create({
      data: {
        userId: id,
        bodyIndex: 1,
        faceIndex: 1,
      },
    });
    await this.setDefaultDecorations(baseCharlie.id);
    return;
  }

  async setDefaultDecorations(charlieId: string): Promise<any> {
    const defaultDecorations = await this.prisma.decoration.findMany({
      where: {
        decorationIndex: 1,
      },
    });
    for (const item of defaultDecorations) {
      await this.prisma.charliedecoration.create({
        data: {
          charlieId: charlieId,
          decorationId: item.id,
          type: item.type,
        },
      });
    }
  }

  async getComponentIndexes(id: string): Promise<any> {
    // get body, face
    const charlie = await this.prisma.charlie.findUnique({
      where: { userId: id },
    });

    // get decorations
    const decorations = await this.prisma.charliedecoration.findMany({
      where: { charlieId: charlie.id },
    });

    const headwearId = decorations.find(
      (item) => item.type === 'headwear',
    ).decorationId;
    const headwearIndex = await this.findDecorationIndex(headwearId);

    const otherId = decorations.find(
      (item) => item.type === 'other',
    ).decorationId;
    const otherIndex = await this.findDecorationIndex(otherId);

    return {
      status: HttpStatus.OK,
      data: {
        body: charlie.bodyIndex,
        face: charlie.faceIndex,
        headwear: headwearIndex,
        other: otherIndex,
      },
    };
  }

  async findDecorationIndex(decorationId: string): Promise<number> {
    const { decorationIndex } = await this.prisma.decoration.findUnique({
      where: { id: decorationId },
    });
    return decorationIndex;
  }

  // async getFaceIndex(id): Promise<number> {
  //   const levelDiff = await this.logService.calcPrevAndTodayLevelDiff(id);
  //   let faces; // 1: plain, 2: happy, 3: sad
  //   let faceIndex: number;
  //   switch (levelDiff) {
  //     case 1: // charlie got HEALTHEIR
  //       faces = [1, 2];
  //       faceIndex = faces[Math.floor(Math.random() * faces.length)];
  //       break;
  //     case -1: // charlie got UNHEALTHIER
  //       faces = [1, 3];
  //       faceIndex = faces[Math.floor(Math.random() * faces.length)];
  //       break;
  //     default:
  //       faceIndex = 1;
  //       break;
  //   }
  //   return faceIndex;
  // }

  // async getDecorationIndex(id: string, type: string): Promise<any> {
  //   const { id: charlieId } = await this.prisma.charlie.findUnique({
  //     where: { userId: id },
  //   });
  //   const decoration = await this.prisma.charliedecoration.findFirst({
  //     where: {
  //       charlieId: charlieId,
  //       type: DecorationType[type],
  //     },
  //   });
  // }
}

export function formatDateToMDY(datetime: Date) {
  const date = datetime.getDate();
  const month = datetime.toLocaleString('default', { month: 'long' });
  const year = datetime.getFullYear();
  return `${month} ${date}, ${year}`;
}

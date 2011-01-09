namespace LandisII.Examples
{
    public static class Ecoregions
    {
        public static readonly int[,] Codes = {
            { 0, 1, 0, 0, 0, 0, 5, 0, 0 },
            { 1, 1, 0, 1, 1, 1, 5, 5, 0 },
            { 1, 1, 1, 1, 1, 1, 5, 5, 5 },
            { 0, 9, 0, 0, 9, 9, 5, 5, 5 },
            { 0, 9, 0, 0, 9, 9, 5, 5, 0 },
            { 9, 9, 9, 9, 9, 0, 5, 5, 0 },
        };

        public static EcoregionGrid CreateGrid()
        {
            return new EcoregionGrid(Codes);
        }
    }
}

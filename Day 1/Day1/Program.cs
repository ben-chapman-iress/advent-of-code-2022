var descendingComparer = Comparer<int>.Create((a, b) => b.CompareTo(a));
var sortedCalories = new SortedSet<int>(descendingComparer);
var calorieCount = 0;

var foodItems = File.ReadAllLines("input.txt");

foreach (var item in foodItems)
{
    if (item.Length > 0)
    {
        calorieCount += int.Parse(item);
        continue;
    }
    
    sortedCalories.Add(calorieCount);
    calorieCount = 0;
}

Console.WriteLine(sortedCalories.Max);
Console.WriteLine(sortedCalories.Take(3).Sum());
Console.ReadLine();
static void AddTo(Dictionary<long, long> dict, long key, long addend)
{
    if (dict.TryGetValue(key, out var existing))
    {
        dict[key] = existing + addend;
    }
    else
    {
        dict[key] = addend;
    }
}

static Dictionary<long, long> Blink(Dictionary<long, long> stones)
{
    var newStones = new Dictionary<long, long>();
    
    foreach (var (stone, value) in stones)
    {
        var digitCount = (int)Math.Floor(Math.Log10(stone)) + 1;
        
        if (stone == 0)
        {
            AddTo(newStones, 1, value);
        }
        else if (digitCount % 2 == 0)
        {
            var factor = Math.Pow(10, (digitCount / 2));
            var left = (long)Math.Floor(stone / factor);
            var right = (long)(stone % factor);
                
            AddTo(newStones, left, value);
            AddTo(newStones, right, value);
        }
        else
        {
            AddTo(newStones, stone * 2024, value);
        }
    }

    return newStones;
}

static List<long> ParseInput(string path)
{
    return File.ReadAllText(path)
        .Split()
        .Select(long.Parse)
        .ToList();
}

var input = ParseInput("input.txt")
    .Select(k => new KeyValuePair<long, long>(k, 1))
    .ToDictionary();

for (var i = 0; i < 75; i++)
{
    input = Blink(input);
}

Console.WriteLine(input.Values.Sum());

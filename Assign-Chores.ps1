$Chores = @(
    "Clean/Set the table",
    "Load/Unload the dishwasher",
    "Gather and take out Trash"
)

$ChoreChart = @{
    Colton  = $null
    Ryder   = $null
    Brendon = $null
}

$Chores = $Chores | Sort-Object { Get-Random }
$Kids = @($ChoreChart.Keys)

for ($i = 0; $i -lt $Kids.Count; $i++)
{
    $ChoreChart[$kids[$i]] = $Chores[$i]
}

$ChoreChart.GetEnumerator() | ForEach-Object  {
    [PSCustomObject]@{
        Child = $_.Key
        Chore = $_.Value
    }
} | Format-Table -AutoSize 


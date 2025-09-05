function Insert-Node
{
    param (
        [int]$Data,
        [PSCustomObject]$LinkedList 
    )

    $node = [PSCustomObject]@{
        Data = $Data
        Next = $LinkedList.Head
    }
    $LinkedList.Head = $node 
}


function Write-ToString
{
    param ([PSCustomObject]$LinkedList)

    $result = ""
    $current = $LinkedList.Head

    while ($current)
    {
        $result += "($($current.Data)) -> "
        $current = $current.Next
    }
    $result += "Null"
    return $result 
}


$ll = [PSCustomObject]@{ Head = $null }
for ($i = 0; $i -lt 10; $i++)
{
    $randomNumber = Get-Random -Minimum 1 -Maximum 100
    Insert-Node -Data $randomNumber -LinkedList $ll
}
Write-ToString -LinkedList $ll | Write-Host 

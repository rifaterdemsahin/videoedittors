$shell = New-Object -ComObject Shell.Application
$folderPath = (Get-Location).Path
$folder = $shell.Namespace($folderPath)

$videos = $folder.Items() | Where-Object {$_.Name -like "*.mp4"} | ForEach-Object {
    $file = $_
    $lengthString = $folder.GetDetailsOf($file, 27)  # 27 is typically the index for Length

    # Convert the length string to a TimeSpan object
    $pattern = '(\d+):(\d{2}):(\d{2})'
    $timeSpan = if ($lengthString -match $pattern) {
        New-TimeSpan -Hours $matches[1] -Minutes $matches[2] -Seconds $matches[3]
    } else {
        New-TimeSpan -Seconds 0  # Default to 0 if no match
    }

    [PSCustomObject]@{
        Name = $file.Name
        Length = $lengthString
        TimeSpan = $timeSpan
    }
}

# Display the list sorted by duration
$sortedVideos = $videos | Sort-Object TimeSpan
$sortedVideos | Format-Table -AutoSize

# Calculate and display the total duration
$totalDuration = New-TimeSpan
$fileCount = $sortedVideos.Count
foreach ($video in $videos) {
    $totalDuration += $video.TimeSpan
}

$totalSeconds = $totalDuration.TotalSeconds
$totalSeconds += ($totalSeconds * 0.03)  # Adding 3% for rounded seconds

$seconds = [math]::Round($totalSeconds)  # Rounding to nearest whole second
$hours = [math]::Floor($seconds / 3600)
$seconds = $seconds % 3600
$minutes = [math]::Floor($seconds / 60)
$seconds = $seconds % 60

"Total Duration: $($hours)h $($minutes)m $($seconds)s, File Count: $fileCount"

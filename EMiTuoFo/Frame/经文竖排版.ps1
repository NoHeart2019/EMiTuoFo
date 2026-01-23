# 读取文件内容
function Read-FileContent {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )
    
    try {
        # 检查文件是否存在
        if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
            throw "文件不存在: $FilePath"
        }
        
        # 读取文件内容，使用 UTF-8 编码
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
        return $content
    }
    catch {
        Write-Error "读取文件时出错: $_"
        exit 1
    }
}

# 处理文本：去除空格和标点符号
function Process-Text {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text
    )
    
    # 去除空格
    $textWithoutSpaces = $Text -replace '\s+', ''
    
    # 去除标点符号（包括中文和英文标点）
    $textWithoutPunctuation = $textWithoutSpaces -replace '[^\p{L}\p{N}]', ''
    
    return $textWithoutPunctuation
}

# 竖版显示文本
function Show-VerticalText {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text,
        [int]$CharsPerColumn = 28
    )
    
    # 计算需要的列数
    $totalChars = $Text.Length
    $columnsNeeded = [math]::Ceiling($totalChars / $CharsPerColumn)
    
    # 创建列数组
    $columns = New-Object string[] $columnsNeeded
    
    # 填充列数组
    for ($i = 0; $i -lt $totalChars; $i++) {
        $colIndex = [math]::Floor($i / $CharsPerColumn)
        $rowIndex = $i % $CharsPerColumn
        
        if ($columns[$colIndex]) {
            $columns[$colIndex] += $Text[$i]
        }
        else {
            $columns[$colIndex] = $Text[$i]
        }
    }
    
    # 输出竖版文本
    for ($row = 0; $row -lt $CharsPerColumn; $row++) {
        $line = ""
        for ($col = $columnsNeeded - 1; $col -ge 0; $col--) {
            if ($row -lt $columns[$col].Length) {
                $line += $columns[$col][$row]
            }
            else {
                $line += " "
            }
        }
        Write-Host $line
    }
}

# 主函数
function Main {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,
        [int]$CharsPerColumn = 28
    )
    
    # 读取文件内容
    $content = Read-FileContent -FilePath $FilePath
    
    # 处理文本
    $processedText = Process-Text -Text $content
    
    # 竖版显示文本
    Show-VerticalText -Text $processedText -CharsPerColumn $CharsPerColumn
}

# 执行主函数
if ($args[1]) {
    $charsPerColumn = [int]$args[1]
} else {
    $charsPerColumn = 28
}
Main -FilePath $args[0] -CharsPerColumn $charsPerColumn
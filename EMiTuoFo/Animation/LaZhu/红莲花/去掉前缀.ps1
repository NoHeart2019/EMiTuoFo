# 设置目标目录路径为当前目录（脚本所在目录）
$Path = $PSScriptRoot

# 设置要移除的前缀
$PrefixToRemove = "8ab23cfa-f1d1-4f04-8c14-9cd998258b6b-"

# 获取目录中所有文件
Get-ChildItem -Path $Path -File | ForEach-Object {
    # 检查文件名是否以前缀开头
    if ($_.Name.StartsWith($PrefixToRemove)) {
        # 构建新文件名（去掉前缀）
        $NewName = $_.Name.Substring($PrefixToRemove.Length)

        # 输出重命名信息（可选）
        Write-Host "Renaming '$($_.Name)' to '$NewName'"

        # 重命名文件
        Rename-Item -Path $_.FullName -NewName $NewName
    }
}
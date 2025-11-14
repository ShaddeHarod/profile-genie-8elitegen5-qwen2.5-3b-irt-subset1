#!/system/bin/sh
# test_over_tag.sh
# [OVER] 标记添加测试脚本
# 用于验证在 output 文件末尾添加 [OVER] 标记的代码是否正确

echo "=== [OVER] 标记添加测试 ==="
echo "测试文件: template_output.txt"
echo ""

# 设置测试文件路径
temp_output="template_output.txt"

# 检查测试文件是否存在
if [ ! -f "$temp_output" ]; then
    echo "错误: 找不到测试文件 $temp_output"
    echo "请确保 template_output.txt 在当前目录下"
    exit 1
fi

echo "正在备份原始文件..."
# 创建备份文件
cp "$temp_output" "${temp_output}.backup"

echo "正在测试 [OVER] 标记添加功能..."
echo ""

# 显示添加前的文件末尾内容
echo "=== 添加前的文件末尾内容 ==="
echo "最后 5 行内容:"
tail -5 "$temp_output"
echo ""

# 测试要验证的两行代码
echo "=== 执行添加 [OVER] 标记的代码 ==="
echo "运行以下命令:"
echo "echo -e \"\\n[OVER]\" >> \"$temp_output\""
echo ""

# 执行代码
echo -e "\n[OVER]" >> "$temp_output"

echo "=== 添加后的文件末尾内容 ==="
echo "最后 5 行内容:"
tail -5 "$temp_output"
echo ""

# 验证添加结果
echo "=== 验证结果 ==="

# 检查文件末尾是否有 [OVER] 标记
last_line=$(tail -1 "$temp_output")
second_last_line=$(tail -2 "$temp_output" | head -1)

if [ "$last_line" = "[OVER]" ]; then
    echo "✅ [OVER] 标记成功添加到文件末尾!"
    echo ""
    echo "验证详情:"
    echo "  - 倒数第二行: '$second_last_line'"
    echo "  - 最后一行: '$last_line'"

    # 检查是否有换行符
    if [ "$second_last_line" = "" ] || [ "${second_last_line}" = "" ]; then
        echo "  - 换行符: ✅ 正确添加了换行符"
    else
        echo "  - 换行符: ⚠️  可能没有正确的换行符"
    fi

    echo ""
    echo "🎉 测试通过! echo -e \"\\n[OVER]\" >> 命令工作正常。"

else
    echo "❌ [OVER] 标记添加失败!"
    echo ""
    echo "失败的原因可能是:"
    echo "  - echo 命令不支持 -e 参数"
    echo "  - 文件权限问题"
    echo "  - 磁盘空间不足"
    echo ""
    echo "实际最后一行内容: '$last_line'"
    echo "期望最后一行内容: '[OVER]'"
    exit 1
fi

echo ""
echo "=== 额外验证 ==="

# 验证文件大小是否增加
original_size=$(wc -c < "${temp_output}.backup")
new_size=$(wc -c < "$temp_output")
size_diff=$((new_size - original_size))

echo "文件大小变化:"
echo "  - 原始文件大小: $original_size 字节"
echo "  - 新文件大小: $new_size 字节"
echo "  - 大小差异: +$size_diff 字节"

# [OVER] 标记应该包含: 换行符(1) + [OVER](5) + 换行符(1) = 7 字节
expected_diff=7
if [ $size_diff -eq $expected_diff ]; then
    echo "  - 大小差异: ✅ 符合预期 (+$expected_diff 字节)"
elif [ $size_diff -gt $expected_diff ]; then
    echo "  - 大小差异: ⚠️  比预期多 (+$((size_diff - expected_diff)) 字节)"
else
    echo "  - 大小差异: ⚠️  比预期少 (+$((expected_diff - size_diff)) 字节)"
fi

echo ""
echo "=== 恢复原始文件 ==="
echo "正在恢复备份..."
mv "${temp_output}.backup" "$temp_output"
echo "✅ 原始文件已恢复"

echo ""
echo "=== 调试信息 ==="
echo "如果需要调试，可以分别运行以下命令:"
echo ""
echo "1. 查看添加前的文件末尾:"
echo "   tail -5 $temp_output"
echo ""
echo "2. 手动执行添加命令:"
echo "   echo -e \"\\n[OVER]\" >> $temp_output"
echo ""
echo "3. 查看添加后的文件末尾:"
echo "   tail -5 $temp_output"
echo ""
echo "4. 验证最后一行是否为 [OVER]:"
echo "   tail -1 $temp_output"
echo ""
echo "5. 检查添加的字符数:"
echo "   wc -c $temp_output"

echo ""
echo "测试完成!"
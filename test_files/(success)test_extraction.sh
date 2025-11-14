#!/system/bin/sh
# test_extraction.sh
# 性能指标提取测试脚本
# 用于验证从 template_profile.txt 中提取性能数据的代码是否正确

echo "=== 性能指标提取测试 ==="
echo "测试文件: template_profile.txt"
echo ""

# 设置测试文件路径
temp_profile="template_profile.txt"

# 检查测试文件是否存在
if [ ! -f "$temp_profile" ]; then
    echo "错误: 找不到测试文件 $temp_profile"
    echo "请确保 template_profile.txt 在当前目录下"
    exit 1
fi

echo "正在从 $temp_profile 中提取性能指标..."
echo ""

# 使用修改后的代码提取性能指标
echo "1. 提取 init-time:"
init_time=$(grep -A1 '"init-time"' "$temp_profile" | grep '"value"' | sed 's/.*"value": \([0-9]*\).*/\1/')
echo "   init_time = $init_time"
echo ""

echo "2. 提取 time-to-first-token:"
prompt_time=$(grep -A1 '"time-to-first-token"' "$temp_profile" | grep '"value"' | sed 's/.*"value": \([0-9]*\).*/\1/')
echo "   prompt_time = $prompt_time"
echo ""

echo "3. 提取 prompt-processing-rate:"
prompt_rate=$(grep -A1 '"prompt-processing-rate"' "$temp_profile" | grep '"value"' | sed 's/.*"value": \([0-9.]*\).*/\1/')
echo "   prompt_rate = $prompt_rate"
echo ""

echo "4. 提取 token-generation-time:"
token_time=$(grep -A1 '"token-generation-time"' "$temp_profile" | grep '"value"' | sed 's/.*"value": \([0-9]*\).*/\1/')
echo "   token_time = $token_time"
echo ""

echo "5. 提取 token-generation-rate:"
token_rate=$(grep -A1 '"token-generation-rate"' "$temp_profile" | grep '"value"' | sed 's/.*"value": \([0-9.]*\).*/\1/')
echo "   token_rate = $token_rate"
echo ""

# 验证提取结果
echo "=== 验证结果 ==="
if [ -n "$init_time" ] && [ -n "$prompt_time" ] && [ -n "$prompt_rate" ] && [ -n "$token_time" ] && [ -n "$token_rate" ]; then
    echo "✅ 所有性能指标都成功提取!"
    echo ""
    echo "提取的数值:"
    echo "  - Init Time: $init_time us"
    echo "  - Time to First Token: $prompt_time us"
    echo "  - Prompt Processing Rate: $prompt_rate toks/sec"
    echo "  - Token Generation Time: $token_time us"
    echo "  - Token Generation Rate: $token_rate toks/sec"
    echo ""
    echo "🎉 测试通过! 修改后的代码工作正常。"
else
    echo "❌ 部分性能指标提取失败!"
    echo ""
    echo "失败的原因可能是:"
    echo "  - JSON 格式不正确"
    echo "  - sed 正则表达式不匹配"
    echo "  - 文件路径错误"
    echo ""
    echo "请检查 template_profile.txt 文件内容和格式。"
    exit 1
fi

echo ""
echo "=== 调试信息 ==="
echo "如果需要调试，可以分别运行以下命令查看详细的提取过程:"
echo ""
echo "调试 init-time:"
echo "grep -A1 '\"init-time\"' $temp_profile"
echo ""
echo "调试 time-to-first-token:"
echo "grep -A1 '\"time-to-first-token\"' $temp_profile"
echo ""
echo "调试 prompt-processing-rate:"
echo "grep -A1 '\"prompt-processing-rate\"' $temp_profile"
echo ""
echo "调试 token-generation-time:"
echo "grep -A1 '\"token-generation-time\"' $temp_profile"
echo ""
echo "调试 token-generation-rate:"
echo "grep -A1 '\"token-generation-rate\"' $temp_profile"
import re

def strip_content(code):
    # Remove multi-line comments
    code = re.sub(r'/\*.*?\*/', '', code, flags=re.DOTALL)
    # Remove single-line comments
    code = re.sub(r'//.*', '', code)
    # Remove strings
    code = re.sub(r'"([^"\\]|\\.)*"', '""', code)
    return code

def check_braces(filename):
    with open(filename, 'r') as f:
        content = f.read()
    
    clean_code = strip_content(content)
    
    opens = clean_code.count('{')
    closes = clean_code.count('}')
    
    print(f"Opens: {opens}, Closes: {closes}")
    
    stack = []
    lines = content.split('\n')
    for line_num, line in enumerate(lines, 1):
        clean_line = strip_content(line)
        for char in clean_line:
            if char == '{':
                stack.append(line_num)
            elif char == '}':
                if not stack:
                    print(f"Excess '}}' at line {line_num}")
                else:
                    stack.pop()
    
    if stack:
        for line_num in stack:
            print(f"Unclosed '{{' at line {line_num}")

check_braces("/Users/apple/Desktop/iMac14/My App copy 2.swiftpm/CipherQuest/Views/Profile/RiddleGridView.swift")

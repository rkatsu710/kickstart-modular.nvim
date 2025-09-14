-- 初期状態ではステータスラインへのIMEの表示はオフ
vim.g.show_ime_status = false

-- モジュールの初期化
-- このモジュールにはIMEの状態を操作・取得する関数
local M = {}

-- IME表示のトグル機能。ステータスラインのIME表示を切り替える
M.toggle_ime_display = function()
    -- IMEのステータスをトグルする
    vim.g.show_ime_status = not vim.g.show_ime_status
    -- ステータスライン再描画して変更をすぐに反映
    vim.cmd("redrawstatus")
end

-- 現在のIMEの入力方法（例：日本語、ローマ字）を
-- ステータスライン用の文字列として返す関数
M.input_method = function()
    -- IMEのステータスが非表示の場合、空文字を返す
    if not vim.g.show_ime_status then
        return ""
    end

    -- macismを使って、現在のIMEの状態を取得
    local handle = io.popen("macism")
    if not handle then
        return "[Error]"
    end
    
    local result = handle:read("*a")
    handle:close()

    -- 結果文字列から末尾の改行文字を削除
    result = result:gsub("\n$", "")

    -- Google日本語入力の場合の判定（より柔軟に）
    if result:match("com%.google%.inputmethod%.Japanese") then
        if result:match("Roman") then
            return " " .. "%#IME_Roman#[" .. "_A" .. "]%*"
        else
            -- Roman以外（base, Japanese, など）は日本語入力とみなす
            return " " .. "%#IME_Japanese#[" .. "あ" .. "]%*"
        end
    -- Mac標準IMEの場合の判定
    elseif result:match("com%.apple%.keylayout%.ABC") then
        return " " .. "%#IME_Roman#[" .. "_A" .. "]%*"
    elseif result:match("com%.apple%.inputmethod%.Kotoeri%.RomajiTyping%.Japanese") then
        return " " .. "%#IME_Japanese#[" .. "あ" .. "]%*"
    -- ATOKの場合の判定
    elseif result:match("atok33%.Roman") then
        return " " .. "%#IME_Roman#[" .. "_A" .. "]%*"
    elseif result:match("atok33%.Japanese") then
        return " " .. "%#IME_Japanese#[" .. "あ" .. "]%*"
    else
        return "[Unknown]"
    end
end

-- デバッグ用：現在のIME識別子を表示する関数
M.show_current_ime = function()
    local handle = io.popen("macism")
    if not handle then
        print("Error: macism command not found")
        return
    end
    
    local result = handle:read("*a")
    handle:close()
    
    result = result:gsub("\n$", "")
    print("Current IME: " .. result)
end

-- モジュールを返す
return M

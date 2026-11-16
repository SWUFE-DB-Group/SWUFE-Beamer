# ==============================================================================
# Makefile for SWUFE Beamer Theme
# ==============================================================================

# 主文档名称（不带扩展名）
TARGET     ?= slide
TEX_SRC     = $(TARGET).tex
PDF_TARGET  = $(TARGET).pdf
DEPS        = $(TEX_SRC) SWUFE.sty $(wildcard ref.bib) $(wildcard pic/*)

# 编译引擎与工具配置
LATEXMK     = latexmk
XELATEX     = xelatex
BIBTEX      = bibtex
VIEWER     ?= xdg-open

# 编译参数
LATEXMK_FLAGS = -xelatex -synctex=1 -interaction=nonstopmode -file-line-error
XELATEX_FLAGS = -synctex=1 -interaction=nonstopmode -file-line-error

# 辅助文件后缀（包含 Beamer 专用文件）
AUX_EXTS = aux bbl blg fdb_latexmk fls log nav out snm toc vrb xdv synctex.gz run.xml bcf

.PHONY: all clean distclean cleanall rebuild view watch pvc xelatex help

# 默认目标：编译生成 PDF
all: $(PDF_TARGET)

# 使用 latexmk 自动处理依赖与多轮编译
$(PDF_TARGET): $(DEPS)
	@echo "==> 使用 latexmk 编译 $(TARGET)..."
	$(LATEXMK) $(LATEXMK_FLAGS) $(TEX_SRC)
	@echo "==> 编译完成: $(PDF_TARGET)"

# 备选编译方式：手动调用 xelatex + bibtex
xelatex:
	@echo "==> [第 1 轮] xelatex 预编译..."
	$(XELATEX) $(XELATEX_FLAGS) $(TEX_SRC)
	@if grep -q '\\bibliography' $(TEX_SRC); then \
		echo "==> 处理文献引用 (bibtex)..."; \
		$(BIBTEX) $(TARGET) || true; \
	fi
	@echo "==> [第 2 轮] xelatex 更新引用..."
	$(XELATEX) $(XELATEX_FLAGS) $(TEX_SRC)
	@echo "==> [第 3 轮] xelatex 生成最终文件..."
	$(XELATEX) $(XELATEX_FLAGS) $(TEX_SRC)
	@echo "==> 编译完成: $(PDF_TARGET)"

# 连续预览编译（监控文件变化自动重编）
watch pvc:
	@echo "==> 启动连续编译与预览模式 (Ctrl+C 退出)..."
	$(LATEXMK) $(LATEXMK_FLAGS) -pvc $(TEX_SRC)

# 打开生成的 PDF
view: $(PDF_TARGET)
	@echo "==> 打开 $(PDF_TARGET)..."
	@$(VIEWER) $(PDF_TARGET) >/dev/null 2>&1 &

# 清理中间编译产物（保留 PDF）
clean:
	@echo "==> 清理中间临时文件..."
	@$(LATEXMK) -c $(TEX_SRC) >/dev/null 2>&1 || true
	@rm -f $(foreach ext,$(AUX_EXTS),$(TARGET).$(ext))
	@echo "==> 中间文件已清理。"

# 彻底清理（包括生成的 PDF）
distclean cleanall: clean
	@echo "==> 清理生成的 PDF 文档..."
	@$(LATEXMK) -C $(TEX_SRC) >/dev/null 2>&1 || true
	@rm -f $(PDF_TARGET)
	@echo "==> 彻底清理完成。"

# 重新完整编译
rebuild: distclean all

# 帮助信息
help:
	@echo "SWUFE Beamer 模板 Makefile 使用说明:"
	@echo ""
	@echo "  make              - 编译并生成 $(PDF_TARGET) (默认使用 latexmk)"
	@echo "  make xelatex      - 手动执行完整流程编译 (xelatex -> bibtex -> xelatex)"
	@echo "  make view         - 用默认 PDF 阅读器打开 $(PDF_TARGET)"
	@echo "  make watch / pvc  - 监视源文件改动并自动重新编译"
	@echo "  make clean        - 清理中间文件 (.aux, .log, .nav, .snm, .toc, .vrb 等)"
	@echo "  make distclean    - 彻底清理，包括生成的 PDF 文件"
	@echo "  make rebuild      - 彻底清理后重新完整编译"
	@echo "  make help         - 显示此帮助信息"
	@echo ""

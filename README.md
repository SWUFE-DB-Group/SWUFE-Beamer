# 西南财经大学 Beamer 幻灯片模板 (SWUFE Beamer Theme)

本项目适用于西南财经大学学术报告、论文开题与答辩、课堂展示等场景的 LaTeX Beamer 幻灯片制作。

- **GitHub 仓库**：[SWUFE-DB-Group/SWUFE-Beamer](https://github.com/SWUFE-DB-Group/SWUFE-Beamer)

## 来源与致谢

本项目来自 [Overleaf SWUFE Beamer Theme 模板](https://www.overleaf.com/latex/templates/swufe-beamer-theme/hysqbvdbpnsm)（作者 Lei Chao），并做了简单修改。

> 注：原模板亦衍生自 [THU-Beamer-Theme](https://github.com/Trinkle23897/THU-Beamer-Theme)。

## 主要修改

- **去除个人身份标记**：移除了原作者的姓名、学院及个人邮箱，替换为通用的模板占位符（如“姓名”、“学院名称”），方便使用者直接替换或按需填写。
- **优化首页 Logo 尺寸与间距**：将首页校徽与校名徽标宽度缩小为适中的比例，移除多余浮动体边距，使封面视觉重心更平衡。
- **增强页脚适应性**：优化了 `SWUFE.sty` 中的页脚判定逻辑，若将作者留空（如用于匿名评审/盲审答辩），页脚不会出现悬空括号与空格。
- **跨平台中文字体自适应**：内置字体检测与分层回退逻辑（优先思源黑体，Windows 自动使用微软雅黑，macOS 自动使用苹方，兜底回退至 TeX 发行版内置的 FandolHei），实现全平台免配置直接编译。
- **公式与字体微调**：公式启用衬线体（`\usefonttheme[onlymath]{serif}`），排版更加工整。
- **提供 Makefile 支持**：支持 `latexmk` 自动化多轮编译、自动清理临时文件及实时监听编译。

## 编译方法

### 依赖环境
- TeX 发行版（推荐 TeX Live 2020 或更新版本 / MacTeX / MiKTeX）
- 编译引擎：**XeLaTeX**（因涉及中文排版，必须使用 XeLaTeX）
- 中文字体：**免手动配置**。模板自动按当前系统适配可用黑体（Linux/Overleaf 优先思源黑体、Windows 微软雅黑、macOS 苹方、TeX Live 发行版内置 FandolHei）

### TexLite（推荐）

推荐使用 **[TexLite](https://github.com/SWUFE-DB-Group/TexLite)** 编写与编译幻灯片。TexLite 是轻量、开箱即用的自托管 LaTeX 工作台，在浏览器中集成了代码编辑、自动编译与 PDF 实时预览，并支持多人协作。

导入本项目后，编译引擎选择 **XeLaTeX**，主文件选择 `slide.tex` 即可一键编译与查看。

### 本地编译

#### Linux / macOS 用户（Makefile）

推荐直接使用附带的 `Makefile`：

```bash
# 默认使用 latexmk 自动处理依赖并生成 slide.pdf
make

# 查看生成的 PDF
make view

# 持续监控文件改动并自动重编（预览模式）
make watch

# 清理编译生成的中间辅助文件（.aux, .log, .nav, .toc 等）
make clean

# 彻底清理（包括生成的 PDF）
make distclean
```

若手动编译，可依次执行：

```bash
xelatex slide.tex
bibtex slide
xelatex slide.tex
xelatex slide.tex
```

#### Windows 用户（Compile.bat）

对于 Windows 用户，我们也提供了批处理编译脚本 `Compile.bat`。可以直接双击运行编译，也可以在命令提示符窗口（cmd / PowerShell）中使用：

```cmd
.\Compile.bat slide          # 默认编译生成 slide.pdf 并清理中间辅助文件
.\Compile.bat clean          # 删除编译所产生的中间文件
.\Compile.bat cleanall       # 删除 slide.pdf 和所有中间文件
.\Compile.bat help           # 查看帮助说明
```

### Overleaf 使用

1. 将本项目所有文件打包为 ZIP 并上传至 Overleaf；
2. 在 Overleaf 菜单（Menu）中，将 **Compiler** 设置为 **XeLaTeX**；
3. 将主文档设为 `slide.tex`，点击 Recompile 即可。

## 文件结构

```text
SWUFE_Beamer_Theme/
├── README.md        # 本说明文档
├── Makefile         # Linux / macOS 编译与管理脚本
├── Compile.bat      # Windows 批处理编译脚本
├── slide.tex        # 幻灯片主文档（示例与内容编写）
├── slide.pdf        # 编译生成的示例 PDF
├── SWUFE.sty        # 西财主题宏包（西财蓝配色、页眉、页脚及样式定义）
├── ref.bib          # 参考文献 BibTeX 文件
└── pic/             # 图片资源目录（包含校徽等素材）
```

\ProvidesClass{gsypset}

\LoadClass[12pt,oneside]{amsart}

\newif\ifgsy@oneperpage
\newif\ifgsy@problemtitles
\newif\ifgsy@printing
\newif\ifgsy@blanks
\newif\ifgsy@needsproblem\gsy@needsproblemtrue
\newif\ifgsy@list
\newif\ifgsy@solutions\gsy@solutionstrue
\DeclareOption{oneperpage}{\gsy@oneperpagetrue}
\DeclareOption{extratitles}{\gsy@problemtitlestrue}
\DeclareOption{problemtitles}{\gsy@problemtitlestrue}
\DeclareOption{printing}{\gsy@printingtrue}
\DeclareOption{blanks}{\gsy@blankstrue}
\DeclareOption{microtype}{\RequirePackage{microtype}}
\DeclareOption{fullproblemnames}{\gsy@needsproblemfalse}
\DeclareOption{list}{%
	\gsy@listtrue%
	\AtBeginDocument{%
		\enumerate%
	}%
	\AtEndDocument{%
		\endenumerate%
	}%
}
\DeclareOption{nosolutions}{\gsy@solutionsfalse}
\ProcessOptions\relax

\RequirePackage{geometry}
\geometry{letterpaper,top=1in,bottom=1in,left=1in,right=1in,headheight=18pt,footskip=24pt}
%\RequirePackage{microtype}
\RequirePackage[onehalfspacing]{setspace}
\RequirePackage{kpfonts}
\RequirePackage{mathrsfs}
%\RequirePackage{lmodern}
%\RequirePackage{fontspec}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{xstring}
\RequirePackage{etoolbox}
\RequirePackage{environ}
\RequirePackage{textcomp}
\RequirePackage[shortlabels]{enumitem}
\RequirePackage{siunitx}
\sisetup{per-mode=fraction}
\sisetup{qualifier-mode=space}
\sisetup{retain-explicit-plus}
\DeclareUnicodeCharacter{00B0}{\degree}
\DeclareSIUnit{\degreeFarenheight}{\degree{}F}
\DeclareSIUnit{\Rxn}{Rxn}
\DeclareSIUnit{\M}{M}
\DeclareSIUnit{\hr}{hr}
\RequirePackage[version=4]{mhchem}
\RequirePackage{chemfig}
\newcommand{\cecol}[2]{\textcolor{#1}{\ce{#2}}}
\RequirePackage{parskip}
\RequirePackage{tikz}
\usetikzlibrary{decorations.pathmorphing}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.13}
\raggedbottom
\allowdisplaybreaks
\RequirePackage{wrapfig}
\RequirePackage{fp}

% definitional commands
\ifgsy@blanks
	\def\gsy@name{\rule{8em}{0.15mm}}
	\newcommand{\name}[1]{}
	\DeclareDocumentCommand{\class}{m g}{%
		\def\gsy@classname{#1}%
		\IfValueTF{#2}{%
			\def\gsy@fullclassname{#1 --- Section \rule{1em}{0.15mm}}
			\def\gsy@sectionname{\rule{1em}{0.15mm}}
		}{%
			\def\gsy@fullclassname{#1}%
		}%
	}
\else
	\def\gsy@name{Gavin Yancey}
	\newcommand{\name}[1]{\def\gsy@name{#1}}

	\DeclareDocumentCommand{\class}{m g}{%
		\def\gsy@classname{#1}%
		\IfValueTF{#2}{%
			\def\gsy@fullclassname{{#1} --- Section {#2}}%
			\def\gsy@sectionname{#2}
		}{%
			\def\gsy@fullclassname{#1}%
		}%
	}
\fi

\newcommand{\assignment}[1]{%
	\IfStrEq{#1}{\empty}{}{%
		\def\gsy@assignment{#1}%
	}%
}
\newcommand{\duedate}[1]{\def\gsy@duedate{#1}}
\newcommand{\problemlist}[1]{\def\gsy@allproblems{#1}}

\newcommand{\gsy@problems}{%
	\ifundef{\gsy@firstproblemnumber}{%
		\ifgsy@needsproblem{Problem }\fi\gsy@problemnumber{} (continued)%
	}{%
		\IfStrEq{\gsy@problemnumber}{\gsy@firstproblemnumber}{%
			\ifgsy@needsproblem{Problem }\fi\gsy@problemnumber%
		}{%
			\ifgsy@needsproblem{Problems }\fi\gsy@firstproblemnumber{} -- \gsy@problemnumber%
		}%
	}%
	\global\undef\gsy@firstproblemnumber%
}

\newcommand{\gsy@updateproblemnumbers}[1]{%
	\global\edef\gsy@problemnumber{#1}%
	\ifundef{\gsy@firstproblemnumber}{%
		\global\edef\gsy@firstproblemnumber{#1}%
	}{}%
}

% problem and solution environments
\newcounter{gsy@problemnumber}\stepcounter{gsy@problemnumber}
\global\newtoggle{gsy@hassubproblems}
\global\newtoggle{gsy@lastsubproblemhadsolution}
\newenvironment{problem}[1][\arabic{gsy@problemnumber}]{%
	\global\togglefalse{gsy@hassubproblems}%
	\ifgsy@problemtitles%
		\textbf{Problem #1}\par%
	\fi%
	\ifgsy@list%
		\item[#1]%
	\fi%
	\gsy@updateproblemnumbers{#1}%
	\stepcounter{gsy@problemnumber}%
}{%
	\iftoggle{gsy@hassubproblems}{%
		\nottoggle{gsy@lastsubproblemhadsolution}{%
			\vfill
		}{}%
		\ifgsy@oneperpage%
			\newpage%
		\fi%
	}{%
		\ifgsy@solutions%
			\vspace{.5\baselineskip}\hrule%
		\else%
			\ifgsy@oneperpage%
				\newpage%
			\else%
				\vfill
			\fi%
		\fi%
	}%
	\global\togglefalse{gsy@hassubproblems}%
}

\newenvironment{problem*}{
	\gsy@needsproblemfalse
	\problem
}{
	\endproblem
}

\newenvironment{subproblems}[1][(a)]{%
	\global\toggletrue{gsy@hassubproblems}%
	\enumerate[#1]%
}{%
	\endenumerate%
}

\newcommand{\subproblem}{%
	\global\togglefalse{gsy@lastsubproblemhadsolution}%
	\item%
}

\newcommand{\solnspace}[1][10em]{%
	\iftoggle{gsy@hassubproblems}{%
		\global\toggletrue{gsy@lastsubproblemhadsolution}%
		\vspace{.5\baselineskip}\hrule%
		\ifgsy@printing%
			\vspace{#1}%
		\fi%
	}{}%
}

\newenvironment{solution}[1][10em]{%
	\solnspace[#1]
}{%
	\iftoggle{gsy@hassubproblems}{
		\vfill%
	}{%
		\ifgsy@oneperpage%
			\newpage%
		\fi%
	}%
}

% headers and footers
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}
\fancyhf{}
\renewcommand{\footrulewidth}{0.4pt}
% blank checking from http://tex.stackexchange.com/a/297755/64177
\lhead{%
	\ifundef{\gsy@assignment}{}{%
		\expandafter\notblank\expandafter{\gsy@assignment}{%
			\gsy@assignment{} --- Due \gsy@duedate\\%
		}{}%
	}%
	\gsy@problems%
}
\chead{}
% blank checking from http://tex.stackexchange.com/a/297755/64177
\rhead{%
	\expandafter\notblank\expandafter{\gsy@name}{%
		\gsy@name\\%
	}{}%
	\gsy@fullclassname%
}
\rfoot{\today}
\@ifpackageloaded{href}{
	\def\lastpageref{\pageref*{LastPage}}
}{
	\def\lastpageref{\pageref{LastPage}}
}
\lfoot{Page \thepage{} of \lastpageref}
\setlength{\headheight}{28pt}
\pagestyle{fancy}
\thispagestyle{fancy}

%======= useful commands =======%

% hack amsmath matrices, adding an optional argument
% that allows you to specify table-like attributes
% so you can, for example, create an augmented matrix
% with a specifier like [ccc|c]
\renewcommand*\env@matrix[1][*\c@MaxMatrixCols c]{%
  \hskip -\arraycolsep
  \let\@ifnextchar\new@ifnextchar
  \array{#1}}

% underlined phantom text (make a blank) with \buline
\RequirePackage[normalem]{ulem}
\newlength{\gsy@widthofcurrentblank}
\newcommand{\blankline}[2][0px]{\uline{\blank[#1]{#2}}}
\newcommand{\blankbox}[2][0px]{\fbox{\blank[#1]{#2}}}
\newcommand{\blank}[2][0pt]{%
	\settowidth{\gsy@widthofcurrentblank}{#2}%
	\ifdim\gsy@widthofcurrentblank<#1%
		\ifgsy@printing%
			\hspace{#1}%
		\else
			\hspace{\dimexpr((#1)-(\gsy@widthofcurrentblank))/2\relax}%
			#2%
			\hspace{\dimexpr((#1)-(\gsy@widthofcurrentblank))/2\relax}%
		\fi
	\else%
		\ifgsy@printing%
			\hspace{\gsy@widthofcurrentblank}%
		\else
			#2
		\fi
	\fi%
}

\newcommand{\dm}[1]{\left|\begin{matrix}#1\end{matrix}\right|}
\newcommand{\bm}[1]{\begin{bmatrix}#1\end{bmatrix}}
\newcommand{\am}[2][]{\begin{bmatrix}[#1]#2\end{bmatrix}}
\def\bv{\bm}
\def\dmatrix{\dm}


\newcommand{\dx}[1]{\;\mathrm{d}#1}
\newcommand{\df}[3][\kern -.5pt]{\frac{\mathrm{d}^{#1}#2}{\mathrm{d}#3^{#1}}}

\newcommand{\fortyfivepreamble}{
	%\usepackage[tmargin=1.25in,lmargin=1in,rmargin=1in,bmargin=1in,paper=letterpaper]{geometry}
	%\usepackage{amsmath}
	\RequirePackage[colorlinks=true]{hyperref}
	%\usepackage{amsfonts}
	%\usepackage{fancyhdr}
	\RequirePackage{graphicx}
	\RequirePackage{calc}
	\RequirePackage{url}
	\renewcommand{\Re}{\mathop{\rm {Re}}}
	\renewcommand{\Im}{\mathop{\rm {Im}}}
	\newcommand{\R}{\mathbb{R}}
	\newcommand{\ra}{\rightarrow}
	\newcommand{\ds}{\displaystyle}
	\newcommand{\mybox}{\mbox{\hspace{.02in}}\fbox{\rule[-1mm]{0mm}{6mm}\hspace{.30in}}\mbox{\hspace{.02in}}}
	\begin{document}
	%
	%\newcounter{probnum}
	%\newenvironment{problems}
	%   {\begin{list}{{\bf \arabic{probnum}:}}%
	%       {\setlength\labelwidth{.25in}%
	%         \setlength\leftmargin{0in}%
	%         \setlength\itemsep{\parsep}%
	%         \usecounter{probnum}}}%
	%   {\end{list}}
	%
	\renewcommand{\theenumi}{\alph{enumi}}
	\renewcommand{\labelenumi}{(\theenumi)}
	\renewcommand{\theenumii}{\arabic{enumii}}
	\renewcommand{\labelenumii}{(\theenumii)}
	%
	\parindent=0pt
	%
	%\pagestyle{fancy}
	%
	%\lhead{Math 45 Spring 2016}
	%\rhead{Profs.\ Levy \& Yong}
}



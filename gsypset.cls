\ProvidesClass{gsypset}

\LoadClass[12pt,oneside]{amsart}

\newif\ifgsy@oneperpage\gsy@oneperpagetrue
\newif\ifgsy@problemtitles
\newif\ifgsy@printing
\newif\ifgsy@blanks
\newif\ifgsy@needsproblem\gsy@needsproblemtrue
\newif\ifgsy@list
\newif\ifgsy@solutions\gsy@solutionstrue
\newif\ifgsy@box
\newif\ifgsy@condensesubproblems
\newif\ifgsy@condensed
\newif\ifgsy@emulatehmc
\newif\ifgsy@needsproblemlist
\DeclareOption{manyperpage}{\gsy@oneperpagefalse}
\DeclareOption{extratitles}{\gsy@problemtitlestrue}
\DeclareOption{problemtitles}{\gsy@problemtitlestrue}
\DeclareOption{printing}{\gsy@printingtrue}
\DeclareOption{blanks}{\gsy@blankstrue}
\DeclareOption{microtype}{\RequirePackage{microtype}}
\DeclareOption{fullproblemnames}{\gsy@needsproblemfalse}
\DeclareOption{boxes}{\gsy@boxtrue}
\DeclareOption{condensed}{\gsy@condensesubproblemstrue\gsy@condensedtrue}
\DeclareOption{hmc}{%
	\gsy@condensesubproblemstrue%
	\gsy@problemtitlestrue%
	\gsy@emulatehmctrue%
	\AtBeginDocument{
		\gsy@writehmcblock%
		\ifundef{\gsy@allproblems}{%
			\gsy@needsproblemlisttrue%
		}{%
			\gsy@writehmcproblemlist%
		}
	}
}
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
\RequirePackage{mathtools}

% definitional commands
\ifgsy@blanks
	\def\gsy@name{\rule{8em}{0.15mm}}
	\newcommand{\name}[1]{}
	\newcommand{\initials}[1]{}
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
	\newcommand{\name}[1]{\def\gsy@name{#1}}
	\newcommand{\initials}[1]{\def\gsy@initials{#1}}
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
\def\mailbox{\name}

\newcommand{\assignment}[1]{%
	\IfStrEq{#1}{\empty}{}{%
		\def\gsy@assignment{#1}%
	}%
}
\newcommand{\duedate}[1]{\def\gsy@duedate{#1}}
\newcommand{\problemlist}[1]{%
	\def\gsy@allproblems{#1}%
	\ifgsy@needsproblemlist%
		\gsy@writehmcproblemlist%
		\gsy@needsproblemlistfalse%
	\fi%
}
\newcommand{\collaborators}[1]{\def\gsy@collaborators{#1}}

\newcommand{\gsy@writehmcblock}{%
	\begin{flushright}
		\ifgsy@box
			Box \#\gsy@name\\%
		\else
			\expandafter\notblank\expandafter{\gsy@name}{%
				\gsy@name\\%
			}{}%
		\fi
		\gsy@fullclassname\\%
		\gsy@assignment\\%
		Due \gsy@duedate%
	\end{flushright}
}

\newcommand{\gsy@writehmcproblemlist}{%
	Problems: \gsy@allproblems%
}

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
\newsavebox{\gsy@hmcproblembox}
\newenvironment{problem}[1][\arabic{gsy@problemnumber}]{%
	\ifgsy@emulatehmc%
		\begin{lrbox}{\gsy@hmcproblembox}\begin{minipage}{\linewidth}%
	\fi%
	\global\togglefalse{gsy@hassubproblems}%
	\ifgsy@problemtitles%
		\ifgsy@needsproblem
			\textbf{Problem #1}\par%
		\else
			\textbf{#1}\par%
		\fi
	\fi%
	\ifgsy@list%
		\item[#1]%
	\fi%
	\gsy@updateproblemnumbers{#1}%
	\stepcounter{gsy@problemnumber}%
}{%
	\ifgsy@emulatehmc%
		\end{minipage}\end{lrbox}\fbox{\usebox{\gsy@hmcproblembox}}%
	\fi%
	\iftoggle{gsy@hassubproblems}{%
		\ifgsy@condensesubproblems%
			\unless\ifgsy@emulatehmc%
				\vspace{.5\baselineskip}\hrule%
			\fi%
		\fi%
		\nottoggle{gsy@lastsubproblemhadsolution}{%
			\vfill%
		}{}%
		\ifgsy@oneperpage%
			\newpage%
		\fi%
	}{%
		\ifgsy@solutions%
			\unless\ifgsy@emulatehmc%
				\vspace{.5\baselineskip}\hrule%
			\fi%
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

\newcommand{\hmcbreakproblem}{%
	\ifgsy@emulatehmc%
		\endproblem%
		\par%
		\addtocounter{gsy@problemnumber}{-1}%
		\problem[\arabic{gsy@problemnumber} (continued)]%
	\fi%
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

\newenvironment{solution}[1][10em]{%
	\iftoggle{gsy@hassubproblems}{%
		\global\toggletrue{gsy@lastsubproblemhadsolution}%
		\unless\ifgsy@condensesubproblems%
			\vspace{.5\baselineskip}\hrule%
		\fi%
		%\ifgsy@printing%
		%	\vspace{#1}%
		%\fi%
	}{}%
	\def\gsy@solnskiplen{#1}
}{%
	\unless\ifgsy@condensesubproblems%
		\iftoggle{gsy@hassubproblems}{%
			\ifgsy@printing%
				\vspace{\gsy@solnskiplen}%
			\fi%
		}{}%
	\fi%
	\iftoggle{gsy@hassubproblems}{
		\unless\ifgsy@condensesubproblems%
			\vfill%
		\fi%
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
	\ifgsy@box
		Box \#\gsy@name\\%
	\else
		\expandafter\notblank\expandafter{\gsy@name}{%
			\gsy@name\\%
		}{}%
	\fi
	\gsy@fullclassname%
}

\@ifpackageloaded{href}{
	\def\lastpageref{\pageref*{LastPage}}
}{
	\def\lastpageref{\pageref{LastPage}}
}

\newcommand{\gsy@collaboratortext}{%
	\ifundef{\gsy@collaborators}{}{%
		\expandafter\notblank\expandafter{\gsy@collaborators}{%
			Collaborators: \gsy@collaborators%
		}{}%
	}%
}

\ifgsy@condensed
	\chead{Page \thepage{} of \lastpageref\\\gsy@collaboratortext}
\else
	\renewcommand{\footrulewidth}{0.4pt}
	\rfoot{\today}
	\cfoot{\gsy@collaboratortext}
	\lfoot{Page \thepage{} of \lastpageref}
\fi
\setlength{\headheight}{28pt}
\ifgsy@emulatehmc
	\pagestyle{plain}
	\thispagestyle{plain}
\else
	\pagestyle{fancy}
	\thispagestyle{fancy}
\fi

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
\newcommand{\pf}[3][\kern -.5pt]{\frac{\partial^{#1} #2}{\partial #3^{#1}}}




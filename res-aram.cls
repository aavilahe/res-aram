% A resume class based off of: http://www.stat.berkeley.edu/~paciorek/computingTips/Latex_template_creating_CV_.html
%
% Author: Aram Avila-Herrera

\NeedsTeXFormat{LaTeX2e}[2014/05/01]
\ProvidesClass{res-aram}[2015/06/26]

% Set the margins
\newlength\thelmargin
\thelmargin=1.5in

\newlength\thesecmargin
\thesecmargin=0.5in

% Load dependencies
\DeclareOption*{\PassOptionsToClass{\CurrentOption,notitlepage}{article}}
\ProcessOptions\relax
\LoadClass{article}
\RequirePackage{calc}              % calculate lengths
%\RequirePackage{fp}               % calculate floats
\RequirePackage[top=1in,
                marginparwidth=\thelmargin-\thesecmargin,
                lmargin=\thelmargin,
                rmargin=\thesecmargin]{geometry}
\RequirePackage{fancyhdr}          % headers
\RequirePackage[compact]{titlesec} % modify sections
\RequirePackage{booktabs}          % prettier table spacing
%\RequirePackage{array}            % \newcolumntype
%\RequirePackage{varwidth}         % variable width minipage
%\RequirePackage{ragged2e}         % fancy Ragged commands
\RequirePackage[inline]{enumitem}  % lists
\RequirePackage{xcolor}            % gray text?
\RequirePackage{etoolbox}          % \ifstrempty, etc...
\RequirePackage{trimspaces}        % trim spaces in address

% More formatting
\raggedbottom

% Description and dates lengths
\newcommand{\descrscale}{0.8}
%\newcommand{\datesscale}{1}  % needed for using varwidth or tabular* to control description width
%\FPsub{\datesscale}{1}{\descrscale}  % needed to set proper tabular* widths

% Maybe use to put address on one line?
% "\\" line breaks to ", " for \mbox{}es
\newcommand{\removelinebreaks}[1]{%
    \begingroup\def\\{, }#1\endgroup}

% Compare strings when they're the output of commands
\newcommand\@ifstrequal{\expandafter\ifstrequal\expandafter}

% Definitions ------------------------------------------------------------------
% Address, emails, names, ...
\newcommand{\theaddress}{}
\newcommand{\@name}{}
\newcommand{\@shortname}{}
\newcommand{\theemail}{}

\newcommand{\address}[1]{%
    \renewcommand{\theaddress}{\trim@spaces{#1}}
}

\newcommand{\email}[1]{%
    \renewcommand{\theemail}{#1}
}

% Optionally set a short name
\newcommand{\name}[2][]{%
    \ifstrempty{#1}{%
        \renewcommand{\@name}{#2}
    }{%
        \renewcommand{\@name}{#2}
        \renewcommand{\@shortname}{#1}
    }
}


% Pagestyle --------------------------------------------------------------------
\fancypagestyle{CVfancytitle}{%
    \fancyhf{}
    \renewcommand{\headrulewidth}{0.1pt}
    \renewcommand{\footrulewidth}{0pt}
    \renewcommand{\headrule}{%
        \hrule width\headwidth
        \vspace{2pt}
        \textcolor{black!50}{\theemail} \hfill
        %\removelinebreaks{\theaddress}
    }
    \fancyhead[L]{{\LARGE\bfseries \@name}}
    \fancyhead[R]{{\itshape p.~\thepage}}
}

\fancypagestyle{CVsimple}{%
    \fancyhf{}
    \renewcommand{\headrulewidth}{0.1pt}
    \renewcommand{\footrulewidth}{0pt}
    \fancyhead[R]{{\itshape \@shortname~p.~\thepage}}
}

\pagestyle{CVsimple}
\thispagestyle{CVfancytitle}


% Section title formatting -----------------------------------------------------
\titleformat{\section}[leftmargin]{%
    \scshape\filright
}{%
    \thesection
}{0pt}{}[]
\titlespacing*{\section}{\marginparwidth}{2ex}{\marginparsep}


% Body formatting  -------------------------------------------------------------
% Add text to body and right margin

% Format using fixed width tabular*
% All entries have same maximum widths, long "#2"s wrap nicely
%\newcolumntype{R}[1]{>{\RaggedLeft\hspace{0pt}}p{#1}}
%\newcolumntype{L}[1]{>{\RaggedRight\hspace{0pt}}p{#1}}
%\newcommand{\@BMentry}[3][]{%
%    \@ifstrequal{#1}{*}{\noindent}{}%
%    \begin{tabular*}{\linewidth}[t]{%
%        @{}L{\descrscale\linewidth}%
%        @{\extracolsep{\fill}}R{\datesscale\linewidth}%
%    }
%        #2 & #3 \\
%    \end{tabular*}
%}

% Format using variable width minipages (but no vertical alignment)
%\newcommand{\@BMentry}[3][]{%
%    \@ifstrequal{#1}{*}{\noindent}{}%
%    \begin{varwidth}{\descrscale\linewidth}
%        {\raggedright #2}
%    \end{varwidth}
%    \hfill
%    \begin{varwidth}{\datesscale\linewidth}
%        {\raggedleft #3}
%    \end{varwidth}
%    \newline
%}

% Format using a simple hfill, long entries get ugly formatting
% Use optional argument [*] to suppress indent (not needed following a new section)
\newcommand{\@BMentry}[3][]{%
    \@ifstrequal{#1}{*}{\noindent}{}%
    #2 \hfill #3\newline
}

\newcommand{\@employer}[2]{%
    \textbf{#1}\ifstrempty{#2}{}{, #2}
}

\newcommand{\experience}[4][]{%
    % *, Employer, City, Dates
    \@BMentry[#1]{\@employer{#2}{#3}}{#4}
}

% awards are now list items for `description' type lists
%\newcommand{\award}[3][]{%
%    % *, Award, Date
%    \@BMentry[#1]{#2}{#3}
%}

\newcommand{\jobtitle}[3][]{%
    % *, Title, Dates
    \@BMentry[#1]{\textit{#2}}{\textit{#3}}
}

\newcommand{\jobdesc}[2][]{%
    \@ifstrequal{#1}{*}{}{\hspace*{1em}}
    \begin{minipage}[t]{\descrscale\linewidth}
        \raggedright
        {#2}
    \end{minipage}
    \newline
}


% Lists ------------------------------------------------------------------------
\newlist{CVitemize}{itemize}{3}
\setlist[CVitemize]{label=\textbullet, nosep,
                    leftmargin=\parindent+\labelwidth}

\newlist{CVinline}{itemize*}{2}
\setlist[CVinline]{label={{\small $\cdot$}},
                   itemjoin={{ }},
                   labelwidth=0pt}

\newlist{CVdescription}{description}{3}
\setlist[CVdescription]{before={\raggedright}, nosep}

\newcommand{\award}[3][]{%
    \item[#1] #2 \ifstrempty{#3}{}{\hfill #3}%
}

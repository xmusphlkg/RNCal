# RNCal
A shinyapp to calculate reproductive number
## Who are you？

我们是厦门大学公共卫生学院的流行病学课题组，我们致力于让中国的基层疾控部门和公共卫生人员用上更加简单易用的工具，让数据分析和可视化不再有门槛，为此我们开发了一系列产品。

这些产品都是在前人工作的基础上开发的，如果您认为我们的工作帮助到了您，请您移步到[`Github`](https://github.com/xmusphlkg/RNCal)为我们点亮一个星星，这是对我们工作最大的肯定。

如果您对于我们的产品感兴趣，欢迎关注我们的微信公众号(CTModelling)。

如果您有新的示例数据，可以发送邮件给[fjmulkg@outlook.com](mailto:fjmulkg@outlook.com)， 并提供相关文献的链接和标题，我们收到后将及时更新示例数据。

## Source Code

[`Github`](https://github.com/xmusphlkg/RNCal)

## Update log

> **V1.0.1  2021/11/30**

> 首次上线，支持Epiestim和EarlyR包计算繁殖数。

> **V1.0.2 2021/12/1**

> 增加数据预览功能，增加R0包计算繁殖数。

> **V1.0.3 2021/12/3**

> 修复部分已知问题，我都不知道修复了啥？

> **V1.1.1 2021/12/10**

> 修复了很多问题，诸如：错别字修改，警告信息不显示，数据空值和缺失导致程序崩溃，支持文件(.xlsx)上传。

> **V1.2.0 2022/03/26**

> 修复数据上传错误，修复日期显示问题和崩溃报错问题。把巨丑的UI改成比较丑，增加测试程序减少崩溃几率。

## Cite

如果我们对您的科研工作有所帮助，亦或是您希望能够引用我们的产品和前人的工作。

### EpiEstim

> Anne Cori, Neil M. Ferguson, Christophe Fraser, Simon Cauchemez, [A New Framework and Software to Estimate Time-Varying Reproduction Numbers During Epidemics](https://doi.org/10.1093/aje/kwt133), American Journal of Epidemiology, Volume 178, Issue 9, 1 November 2013, Pages 1505–1512.

> @misc{Cori2021,
 author={Cori, A and Kamvar, ZN and Stockwin, J and Jombart, T and Dahlqwist, E and FitzJohn, R and Thompson, R},  
 year={2021},  
 title={{EpiEstim v2.2-3: A tool to estimate time varying instantaneous reproduction number during epidemics}},  
 publisher={GitHub},
 journal={GitHub repository},  
 howpublished = {\url{https://github.com/mrc-ide/EpiEstim}},
 commit={c18949d93fe4dcc384cbcae7567a788622efc781},  
}

### R0

>Obadia, T., Haneef, R. & Boëlle, PY. The R0 package: a toolbox to estimate reproduction numbers for epidemic outbreaks. BMC Med Inform Decis Mak 12, 147 (2012). https://doi.org/10.1186/1472-6947-12-147

>@article{pmid:23249562,
	journal = {BMC medical informatics and decision making},
	doi = {10.1186/1472-6947-12-147},
	issn = {1472-6947},
	pmid = {23249562},
	pmcid = {PMC3582628},
	publisher = {BioMed Central},
	title = {The R0 package: a toolbox to estimate reproduction numbers for epidemic outbreaks},
	volume = {12},
	author = {Obadia, Thomas and Haneef, Romana and Boëlle, Pierre-Yves},
	note = {[Online; accessed 2021-11-16]},
	pages = {147},
	date = {2012-12-18},
	year = {2012},
	month = {12},
	day = {18},
}

### earlyR

> Anne Cori, Neil M. Ferguson, Christophe Fraser, Simon Cauchemez, A New Framework and Software to Estimate Time-Varying Reproduction Numbers During Epidemics, American Journal of Epidemiology, Volume 178, Issue 9, 1 November 2013, Pages 1505–1512, https://doi.org/10.1093/aje/kwt133

> @article{pmid:24043437,
	journal = {American journal of epidemiology},
	doi = {10.1093/aje/kwt133},
	issn = {0002-9262},
	number = {9},
	pmid = {24043437},
	pmcid = {PMC3816335},
	publisher = {Oxford University Press},
	title = {A new framework and software to estimate time-varying reproduction numbers during epidemics},
	volume = {178},
	author = {Cori, Anne and Ferguson, Neil M and Fraser, Christophe and Cauchemez, Simon},
	note = {[Online; accessed 2021-11-16]},
	pages = {1505--12},
	date = {2013-11-01},
	year = {2013},
	month = {11},
	day = {1},
}

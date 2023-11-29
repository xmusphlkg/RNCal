## Introduction

A shinyapp to calculate reproductive number. The project has been published in China CDC Weekly (doi: 10.46234/ccdcw2023.158), and we encourage you to cite this project if you find it useful for your work.

用于计算再生数的交互式网页，项目工作已经发表在 China CDC Weekly 上 (doi: 10.46234/ccdcw2023.158)，如果本项目对你的工作有帮助欢迎引此项目。

> Kangguo Li, Jiayi Wang, Jiayuan Xie, Jia Rui, Buasiyamu Abudunaibi, Hongjie Wei, Hong Liu, Shuo Zhang, Qun Li, Yan Niu, Tianmu Chen. Advancements in Defining and Estimating the Reproduction Number in Infectious Disease Epidemiology[J]. China CDC Weekly, 2023, 5(37): 829-834. doi: 10.46234/ccdcw2023.158

## Who are you？

我们是厦门大学公共卫生学院的流行病学课题组，我们致力于让中国的基层疾控部门和公共卫生人员用上更加简单易用的工具，让数据分析和可视化不再有门槛，为此我们开发了一系列产品。

这些产品都是在前人工作的基础上开发的，如果您认为我们的工作帮助到了您，请您移步到[`Github`](https://github.com/xmusphlkg/RNCal)为我们点亮一个星星，这是对我们工作最大的肯定。

如果您对于我们的产品感兴趣，欢迎关注我们的微信公众号(CTModelling)。

如果您有新的示例数据，可以发送邮件给[fjmulkg@outlook.com](mailto:fjmulkg@outlook.com)， 并提供相关文献的链接和标题，我们收到后将及时更新示例数据。

## Source Code

[`Github`](https://github.com/xmusphlkg/RNCal)

## Update log

> **V1.0.1 2021/11/30**

> 首次上线，支持 Epiestim 和 EarlyR 包计算繁殖数。

> **V1.0.2 2021/12/1**

> 增加数据预览功能，增加 R0 包计算繁殖数。

> **V1.0.3 2021/12/3**

> 修复部分已知问题，我都不知道修复了啥？

> **V1.1.1 2021/12/10**

> 修复了很多问题，诸如：错别字修改，警告信息不显示，数据空值和缺失导致程序崩溃，支持文件(.xlsx)上传。

> **V1.2.0 2022/03/26**

> 修复数据上传错误，修复日期显示问题和崩溃报错问题。把巨丑的 UI 改成比较丑，增加测试程序减少崩溃几率。

> **V1.3.0 2022/08/22**

> 修复分布拟合错误，添加多个有效再生数计算错误。

> **V1.3.1 2022/10/14**

> 增加提示。

> **V1.3.2 2022/10/19**

> 增加提示。

> **V2.0.1 2023/11/23**

> 重构 UI，修复多个已知问题。

> **V2.0.2 2023/11/24**

> 增加代码生成和 docker container 位置显示，增加示例文件下载。

> **V2.0.3 2023/11/29**

> 修复代码生成错误。

## Cite

如果我们对您的科研工作有所帮助，亦或是您希望能够引用我们的产品和前人的工作。

### EpiEstim

> Anne Cori, Neil M. Ferguson, Christophe Fraser, Simon Cauchemez, [A New Framework and Software to Estimate Time-Varying Reproduction Numbers During Epidemics](https://doi.org/10.1093/aje/kwt133), American Journal of Epidemiology, Volume 178, Issue 9, 1 November 2013, Pages 1505–1512.

> @misc{Cori2021,
> author={Cori, A and Kamvar, ZN and Stockwin, J and Jombart, T and Dahlqwist, E and FitzJohn, R and Thompson, R},  
>  year={2021},  
>  title={{EpiEstim v2.2-3: A tool to estimate time varying instantaneous reproduction number during epidemics}},  
>  publisher={GitHub},
> journal={GitHub repository},  
>  howpublished = {\url{https://github.com/mrc-ide/EpiEstim}},
> commit={c18949d93fe4dcc384cbcae7567a788622efc781},  
> }

### R0

> Obadia, T., Haneef, R. & Boëlle, PY. The R0 package: a toolbox to estimate reproduction numbers for epidemic outbreaks. BMC Med Inform Decis Mak 12, 147 (2012). https://doi.org/10.1186/1472-6947-12-147

> @article{pmid:23249562,

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

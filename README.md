# README
## 简介
对Robust Multi-object Tracking by Marginal Inference论文中提出的通过边缘概率计算代价矩阵从而提升追踪中匹配效果方法进行复现。目标追踪需要考虑检测器、ReID提取器和追踪器三部分。由于文中有在FairMOT基础上的实验部分，而我对相关模型较为熟悉，简便起见选择在FairMOT基础上进行复现。如果使用其他的检测器和ReID提取器，使用本代码中的src/lib/tracker部分作为tracker部分即可实现对应功能。

最主要的改进部分在src/lib/tracker部分，在matching.py中添加了margin_pr_distance函数，该函数接受代价矩阵，通过本论文算法计算得到并返回边缘概率组成的代价矩阵。

运行代码首先配置环境：
```shell
conda create -n FairMOT
conda activate FairMOT
conda install pytorch==1.7.0 torchvision==0.8.0 cudatoolkit=10.2 -c pytorch
cd ${FAIRMOT_ROOT}
pip install cython
pip install -r requirements.txt
git clone -b pytorch_1.7 https://github.com/ifzhang/DCNv2.git
cd DCNv2
./make.sh
```
此后需要下载MOT17和MOT20数据集：
```shell
cd ${FAIRMOT_ROOT}/..
mkdir dataset
cd dataset
wget https://motchallenge.net/data/MOT17.zip
unzip MOT17.zip
wget https://motchallenge.net/data/MOT20.zip
unzip MOT20.zip
```
接下来可以运行实验，通过运行experiments中的脚本，可以进行对应实验。脚本名称中下滑线前表示使用的数据集，后表示使用的模型。

notes.md为论文笔记。
## 复现结果
FairMOT在MOT17数据集上的验证结果（val17）
![](/assets/fairmot_mot17.png)
使用本论文方法改进后的验证结果（val17）
![](/assets/marginal_pr_mot17.png)
FairMOT在MOT20数据集上的验证结果（val20）
![](/assets/fairmot_mot20.png)
使用本论文方法改进后的验证结果（val20）
![](/assets/marginal_pr_mot20.png)
在MOT20数据集上对各个阈值超参数进行消融实验，测试了检测阈值conf_thres和第一次匹配使用的代价矩阵阈值tp对结果的影响。

消融实验：conf_thres参数的影响：
![](/assets/conf_ablation.png)
消融实验：tp参数的影响（tp列为代价矩阵阈值参数取值，最后一行为FairMOT结果（baseline））：
![](/assets/tp_ablation.png)
## 复现时间线
- 3.28 午晚 一直在上课
- 3.29 早上 阅读Robust Multi-object Tracking by Marginal Inference论文
- 3.29 午晚 阅读SORT、DeepSORT、FairMOT等论文（以前没有系统了解过目标追踪，读一些相关论文理解目标追踪整体框架）
- 3.30 早上 重读Robust Multi-object Tracking by Marginal Inference论文，研究相关的优化知识
- 3.30 下午 复习FairMOT代码 ，在此基础上实现基于边缘概率的代价矩阵
- 3.30 晚上 准备MOT17、MOT20数据集，配置好运行环境，跑通代码
- 3.31 早上 又上了一个早上的课
- 3.31 下午 运行得到FairMOT在两个数据集上的运行结果作为baseline，发现边缘概率计算中的bug后跑通代码。
- 3.31 晚上 按照论文中参数在数据集上进行验证
- 4.1 早上 整理一下代码，重新写了一下实验运行脚本，添加阈值作为命令行参数方便实验
- 4.1 午晚 验证各个阈值超参数对模型的影响
- 4.2 早午 用来运代码的服务器登不上去被迫摸鱼，登上之后整理代码和结果
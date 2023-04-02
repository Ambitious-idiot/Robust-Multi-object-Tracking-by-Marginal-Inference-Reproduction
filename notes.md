# Yifu Zhang, Chunyu Wang, Xinggang Wang, Wenjun Zeng, Wenyu Liu(2022) - Robust Multi-object Tracking by Marginal Inference
## Intro
对于不同的视频难以确定一个恒定的特征距离阈值。使用边缘概率进行单一阈值的检测。枚举所有可能匹配复杂度过高，计算少量低成本支撑集，该算法与匈牙利算法的MAP解重叠。
## Method
第$t$帧，$M$个检测结果，$N$个追踪，对应的Re-ID特征为$d_t^1,\dots,d_t^M,h_t^1,\dots,h_t^N$，余弦相似度计算代价矩阵$S_t$：
$$
S_t(i,j)=\frac{d_{T}^{i}\cdot h_{t}^{j}}{||d_{t}^{i}||||h_{t}^{j}||}
$$
$\mathbb{A}$表示所有可能的匹配结果的集合，其中元素为$M\times N$ 矩阵，矩阵元素为0或1，满足每行和、每列和小于等于1。对于其中元素$A$，其概率为
$$
p(A)=\Pi\Big(\frac{\exp S_{t}(q,r)}{\sum\limits_{1}^{N}\exp(S_{t}(q,r))}\Big)
$$
$\mathbb{A}_{ij}$为$\mathbb{A}$子集，满足(i, j)位等于1。
计算边缘分布矩阵$P_t$，$P_t(i,j)$表示第i个检测匹配第j个轨迹的概率。
$$
P_t(i,j)=\sum\limits_{A\in\mathbb{A}_{ij}}p(A)
$$
将$\mathbb{A}$中元素拉平为$MN$维向量$k$，所有$k$组成$MN\times D$矩阵$K$，将$S_t$拉平为$MN$维向量$S$。
将匹配问题视为一个结构化预测问题，使用对数势进行参数化。对于每一种匹配方案，注意到MAP原则可以将每种方案分数表示为$\theta=K^{T}S$。令$y$为满足仅一位为1其余位为0的$D$维向量，则最大后验为：
$$
\begin{align*}
MAP_{K}(S)&=\arg\max_{y}\theta^{T}y\\
&=\arg\max_{y}S^{T}Ky\\
&=\arg\max_{k}S^{T}k
\end{align*}
$$
该问题的主要问题在于$D$很大，采用正则化的MAP求解：
$$
\begin{align*}
L2MAP_{K}(S)&=\arg\max \theta^Ty-\frac{1}{2}||Ky||^{2}_{2}\\
&=\arg\max S^Tk-\frac{1}{2}||k||^{2}
\end{align*}
$$
Frank-Wolfe算法求解以上问题：
$$
\begin{align*}
f(k)&=S^{T}k-\frac{1}{2}||k||^{2}\\
\hat{f}(k)&=(\nabla_{k}f)^{T}k=(S-k^\prime)^{T}k
\end{align*}
$$

转换为对该函数的优化问题，在小邻域内与原问题优化等价。该式与问题定义中的MAP形式相同，即同样为一个匹配问题，每一步可以应用匈牙利算法求解出高分结构$z$，再用$z$代替$k^\prime$，重复若干次得到高分结构集合$\mathbb{Z}=\{z_{1},\dots,z_{n}\}$，该集合构成所有方案集合的支撑集，可以直接利用该集合计算边缘概率，带入公式为：
$$
P_{t}(i,j)=\sum\limits_{z\in\mathbb{Z}_{i,j}}\Big(\frac{\exp(-S^{T}z)}{\sum\limits\exp(-S^{T}z_{v})}\Big)
$$
将直接使用余弦相似度做代价矩阵转换为利用余弦相似度矩阵推导边缘概率矩阵作为代价矩阵。追踪部分采用与[[FairMOT_ On the Fairness of Detection and Re-identification in Multiple Object Tracking_2021]]相同的流程：将匹配分为层次化的两个阶段：
1. 通过Re-ID特征计算代价矩阵并融入运动的马氏距离（加权求和）匹配：
$$
D_{p}=\omega(1-P_{t})+(1-\omega)M_{t}
$$
2. IoU匹配。

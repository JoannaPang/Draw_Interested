#step2:（ubuntu）

import matplotlib.pyplot as plt
import numpy as np
#from numpy import random
import pandas as pd


import codecs
 
f = codecs.open('text.txt', mode='r', encoding='utf-8') # 打开txt文件，以‘utf-8'编码读取
line = f.readline()  # 以行的形式进行读取文件
listX = []
listY = []
while line:
  a = line.split()

  X = a[0:1]  # 这是选取需要读取的位数
  #print(type(X[0]))
  #X[0] = (X[0][1:-1])
  X = int(X[0][1:-1]) #list中取出字符串，获得需要的数字部分，并将其转化为数字，再存入list
  #print(X[0][1:-1])
  Y = a[1:2]
  #Y[0] = (Y[0][:-3])
  Y = float(Y[0][:-3])
  #print(Y)
  listX.append(X) # 将其添加在列表之中
  listY.append(Y)
  line = f.readline()
f.close()

'''
for i in listX:
  print(i)
for i in listY:
  print(i)
'''
#print(listX)
#print(listY)


#height = [1,2,3]
#weight = [3,5,6]
X_data = listX
Y_data = listY

#print(type(X_data))

N = len(X_data)
#colors = np.random.rand(N) # 随机产生50个0~1之间的颜色值
#col=['c', 'b', 'g', 'r', 'c', 'm', 'y', 'k', 'w']
col=['c', 'b', 'g', 'r', 'c', 'm', 'y', 'k'] #边界颜色不能设为白色，否则会看不到
len_col = len(col)
#area = np.pi * (10 * np.random.rand(N))**2  # 点的半径范围:0~15 

#markers_market=['.', ',', 'o', 'v', '^', '<', '>', '1', '2', '3', '4', '8', 's', 'p', 'P', '*', 'h', 'H', '+', 'x', 'X', 'D', 'd', '|', '_']
markers_market=['.', ',', 'o', 'v', '^', '<', '>', '8', 's', 'p', 'P', '*', 'h', 'H', 'D', 'd'] #剔除那些没有边界的markers
len_markers = len(markers_market)
#print(np.random.randint(len_markers))
#print(markers_market[0])
#markers_market[np.random.randint(len_markers)] #[0,len_markers)
for i in range(len(X_data)):
  plt.scatter(X_data[i], Y_data[i], c='',s=200, alpha=1, marker=markers_market[np.random.randint(len_markers)],edgecolors=col[np.random.randint(len_col)],linewidths=2)
  #plt.scatter(X_data[i], Y_data[i], s=200, alpha=1, marker=markers_market[np.random.randint(len_markers)],edgecolors=col[np.random.randint(len_col)])




maxX = max(X_data)
minX = min(X_data)

maxY = max(Y_data)
minY = min(Y_data)
plt.xlim(minX-3, maxX+3)
plt.ylim(minY-5, maxY+5)
plt.axis()
#plt.grid(linestyle='--')
for i in range(len(X_data)):
  my_line=plt.plot([X_data[i],X_data[i]],[Y_data[i],0], linestyle=':',color='gray',alpha=0.4)

'''
ax = plt.axes([minX, minY, maxX, maxY])
ax.xaxis.set_major_locator(plt.MultipleLocator(1.0))#设置x主坐标间隔 1
ax.grid(which='major', axis='x', linewidth=0.75, linestyle='-', color='1')
'''

# 设置横纵坐标的名称以及对应字体格式
font1 = {'family': 'Times New Roman',
         'weight': 'normal',
         'size': 16,
         }

    # 设置title和x，y轴的label
plt.title("Numbers And Fps",font1)
plt.xlabel("Numbers",font1)
plt.ylabel("Fps",font1)



#获得坐标轴的句柄 
ax=plt.gca();

# 设置坐标刻度值的大小以及刻度值的字体
plt.tick_params(labelsize=15,width=2,bottom=True,top=True,left=True,right=True,direction='in')
#tick_labels = ax.get_xticklabels() + ax.get_yticklabels()
#[label.set_fontname('Times New Roman') for label in tick_labels]

###设置坐标轴的粗细 

ax.spines['bottom'].set_linewidth(2);
###设置底部坐标轴的粗细 
ax.spines['left'].set_linewidth(2);
####设置左边坐标轴的粗细 
ax.spines['right'].set_linewidth(2);
###设置右边坐标轴的粗细 
ax.spines['top'].set_linewidth(2);
####设置上部坐标轴的粗细 





    # 保存图片到指定路径
plt.savefig("lalala2.png")
    # 展示图片 *必加
plt.show()


'''
df=pd.DataFrame({'x':range(1,101),'y':np.random.randn(100)*80+range(1,101)})


# === Left figure:
plt.plot( 'x', 'y', data=df, linestyle='none', marker='*')
plt.show()

# === Right figure:
all_poss=['.','o','v','^','>','<','s','p','*','h','H','D','d','1','','']
 
# to see all possibilities:
# markers.MarkerStyle.markers.keys()
 
# set the limit of x and y axis:
plt.xlim(0.5,4.5)
plt.ylim(0.5,4.5)
 
# remove ticks and values of axis:
plt.xticks([])
plt.yticks([])
#plt.set_xlabel(size=0)
 
# Make a loop to add markers one by one
num=0
for x in range(1,5):
  for y in range(1,5):
    num += 1
    plt.plot(x,y,marker=all_poss[num-1], markerfacecolor='orange', markersize=23, markeredgecolor="black")
    plt.text(x+0.2, y, all_poss[num-1], horizontalalignment='left', size='medium', color='black', weight='semibold')
plt.show()
'''




#step1:

#awk '{print $1,$7}' fps.txt | tee text.txt
#获取fps.txt中的第一列和第七列，并把其保存到text.txt中，同时打印到屏幕上



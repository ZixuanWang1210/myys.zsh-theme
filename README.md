# myys.zsh-theme

使用了oh-my-zsh主题后，发现conda环境名称不能显示如下图：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190911205535355.png)

经过一番改进后，效果图如下：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190911205615114.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190911205832390.png)

## 使用方法
1 将myys.zsh-theme文件拷贝到~/.oh-my-zsh/themes下

2 修改~/.zshrc中的theme配置为myys

3 激活 `source ~/.zshrc`

4 在`~/.condarc`中添加`changeps1: False`

`conda config --set changeps1 False`

# myys_v2.zsh-theme

![在这里插入图片描述](https://img-blog.csdnimg.cn/55bf1c99ca7e462a807d86eaa2509091.png)

<hr>
更新：

- 2019.9.12：修复BUG（连续使用Tab导致当前命令行乱码）
- 2021.11.29：更新V2版本，优化界面，显示IP地址。
- 2024.11.6：修复BUG（IP地址获取出错）

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/marlonrichert/zsh-autocomplete ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
plugins=(
     git
     zsh-autocomplete
     zsh-autosuggestions
     zsh-syntax-highlighting
     z
     # autocd
)
```

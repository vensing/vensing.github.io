---
title: 我的小伙伴们 ~
date: 2019-01-31 20:29:05
type: "friends"
toc: false
comments: true
---


###  友情链接 

**友情链接**，或称**交换连结**，就是指两个或者以上的网站互相放上对方的链接，达到向用户推荐以互相共享用户群的一种SEO方式。连结的方法通常是在网站上放上对方网站的文字连结或图片（一般是对方的 Logo) 连结。

**友情链接**在非营利网站上更为常见，例如个人网站，明星偶像网站，或聊天讨论区。

博客本来是一个独立的点，通过友情链接能够让不同的人连接到一块，以及让更多的人相互了解和认识。

如果你来到了本页面，不妨点进下方[“我的小伙伴们”](/friends/#我的小伙伴们)中的友情链接去看看，尝试认识更多有趣的人。

### 我的小伙伴们

<div class="linkpage"><ul id="friendsList"></ul></div>

<script type="text/javascript">
// 以下为样例内容，按照格式可以随意修改
var myFriends = [
    ["https://candinya.com/", "https://cn.gravatar.com/avatar/a7f9e15fef26e0a540edc977e21cb3eb", "@糖喵🍬", "要来根🍭嘛~"], 
    ["https://www.mintimate.cn/", "https://puui.qpic.cn/fans_admin/0/3_1680187318_1573736162839/0", "@Mintimate", " ο(=•ω＜=)ρ，酷安机油 ~，奥利给"], 
    ["https://www.hqsblog.cn/", "https://secure.gravatar.com/avatar/bf26ba39de8953a3629b16a30c5f1dbe?s=40&r=G&d=", "@寒穹の小屋", "喜欢追番、打游戏、听音乐的好学生"],
    ["https://bwoywan268.xyz/", "https://vensing.com/images/avatar.png", "@博源", "人生如逆旅，我亦是行人"], 
    ["https://sanshiliuxiao.top/", "https://cdn.jsdelivr.net/gh/sanshiliuxiao/blog-static/avatar.jpg", "@椎咲良田", " 昨日、今日、明日，前端大佬 ( =•ω＜= )✧"], 
    ["https://mqaq.fun/", "https://vensing.com/images/avatar.png", "@一叶竹", "是一个喜欢二次元的蓝孩纸喔 ~"],
    ["https://blog.badapple.pro/", "https://cn.gravatar.com/avatar/cc6a1849aa21339b96dd2a7c913dc435", "@东方幻梦", "只是当时已惘然，沉溺梦中不愿醒来。"],
    ["https://blog.imgradeone.xyz/", "https://blog.imgradeone.xyz/images/avatar.png?v=1585924114010", "@一么酱", "(妹妹酱？猜测)萌站 一 丧病至极的一么酱的官网。"], 
    ["https://removeif.github.io/", "https://cdn.jsdelivr.net/gh/removeif/removeif.github.io@latest/img/avatar.png", "@辣椒の酱", " 尚未执佩剑，转眼即江湖。后端开发，技术分享。"], 
    ["https://www.senventise.com/", "https://public-res-1256129046.cos.ap-shanghai.myqcloud.com/avatar.png", "@Senventise", "Steam 游戏大佬，Galgame 爱好者。"],
    ["https://raspii.tech/", "https://vensing.com/images/avatar.png", "@无用挂件の日历", "无用挂件の日历 ο(=•ω＜=)ρ。"], 
    ["https://zhangyijia.eu5.org/", "https://cdn.jsdelivr.net/gh/miku-o/imgData/5c3aedy7.jpg", "@ZhangYiJia", " 我们所过的每个平凡的日常，也许就是连续发生的奇迹"], 
    ["https://angelni.github.io/", "https://cdn.jsdelivr.net/gh/AngelNI/CDN@3.0/imgs/avatar.png", "@AngelNI", "A HPU‘s student。"],
    ["https://eanraig.xyz/", "https://cdn.jsdelivr.net/gh/eanraig/ghost-assets/img/2020/04/avatar.jpg", "@eanraig", "他没有更多信息！"],
    ["https://type.zhoublog.xyz/", "https://ae01.alicdn.com/kf/Ua037dc8b478d4c2ca8fc8ebcdfe589bcj.png", "@_Zhou_", "一名来普普通通的学生(其实是大佬哒)"],
    ["https://skyblond.info/", "https://secure.gravatar.com/avatar/b8dd5801979dc700a9cc29ef793f3357", "@天空Blond", "推油，精神神楽坂 ←不是，绝对不是"],
    ["https://raptazure.github.io/", "https://cdn.jsdelivr.net/gh/raptazure/cdn/blog/avatar.jpg", "@Raptazure", "推油，心随自然"],
    ["https://nek0ri.de/", "https://pic.imgdb.cn/item/5e43fc102fb38b8c3cdb23dc.png", "@猫梨の部屋", "我们能做得更好"],
    ["https://cwksc.github.io/", "https://cwksc.github.io/assets/image/author_photo/CWKSC_photo.jpg", "@CWKSC", "主要是写技术文章的，有时候是日常，吐槽"],
    ["http://www.lionad.art/", "http://image.lionad.art/mgear/image/avatar.gif", "@lionad", "前端工程师，有技术激情和生活态度|午夜吉他魔|兴趣泛滥的游戏玩家"]
];

// 以下为核心功能内容，修改前请确保理解您的行为内容与可能造成的结果
var  targetList = document.getElementById("friendsList");
while (myFriends.length > 0) {
    var rndNum = Math.floor(Math.random()*myFriends.length);
    var friendNode = document.createElement("li");
    var friend_link = document.createElement("a"), 
        friend_img = document.createElement("img"), 
        friend_name = document.createElement("h4"), 
        friend_about = document.createElement("p")
    ;
    friend_link.target = "_blank";
    friend_link.href = myFriends[rndNum][0];
    friend_img.src=myFriends[rndNum][1];
    friend_name.innerText = myFriends[rndNum][2];
    friend_about.innerText = myFriends[rndNum][3];
    friend_link.appendChild(friend_img);
    friend_link.appendChild(friend_name);
    friend_link.appendChild(friend_about);
    friendNode.appendChild(friend_link);
    targetList.appendChild(friendNode);
    myFriends.splice(rndNum, 1);
}
</script>


### 友链申请

与我交互友链，你只需要有一定数量的文章和有趣的内容即可。

通过以下格式给我留言或者给我发邮件即可：

- [站点名称]：芝士部落格
- [个人形象]：https://www.gravatar.com/avatar/1269adc0efdb4529b560b4faca2b6d73?s=400
- [站点地址]：https://www.vensing.com
- [站点描述]：有梦想，也有忧伤和理想

发邮件添加友链：
dmVuc2luZ0Bmb3htYWlsLmNvbQ== (base64)






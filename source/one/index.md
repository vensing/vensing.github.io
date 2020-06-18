---
title: ONE 每日图文
date: 2020-06-18 12:29:05
type: "one"
toc: false
comments: false
---


<script>
;(function(){

  $.ajax({
      url: 'https://green-cloud-7dfe.vensing.workers.dev/',
      type: 'get',
      dataType: "json",
      success: result => {
        if(result && result.res === 0){
          var datas = result.data;
          $('.kratos-post-content').append(
          '<div style="text-align:center;"><div><p style="font-size:28px;margin: 0.5em;">'+ datas[0].date + '</p>'+
          '<p style="margin-top: 0em;">'+ datas[0].title +'</p></div>'+
          '<img src="'+ datas[0].img_url +'"></img>'+
          '<div><p style="font-size:12px;">'+ datas[0].picture_author +'</p></div>'+
          '<div><p>'+ datas[0].content +'</p></div>' + 
          '<div><p>'+ datas[0].text_authors +'</p></div>'+
          '<div><a href="http://wufazhuce.com/">ONE | 一个</a></div></div>'
          );
        }else{
          $('.kratos-post-content').append("<p>哎呀，每日一图崩溃了o(≧口≦)o</p>");
        }
      }
    })

})();
</script>


---
title: 豆瓣电影日历
date: 2020-06-21 14:25:05
type: "movie"
toc: false
comments: false
---


<script>
;(function(){

  $('.kratos-post-content > h2').next().remove();
  var url = 'https://today-douban.vensing.workers.dev/api/v2/calendar/today';
  var now = new Date();
  var year = now.getFullYear();
  var month = now.getMonth() + 1;
  var date = now.getDate();
  $.ajax({
      url: url,
      type: 'get',
      dataType: "json",
      data: {
        _sig: 'wrbnosUhjy0QYJGWQD7TRutXVgk=',
        date: year + '-' + month + '-' + date,
        apikey: '0ab215a8b1977939201640fa14c66bab',
        alt: 'json',
        _ts: '1592712181'
      },
      success: result => {
        if(result.today && result.comment){
          let html = `
            <div style="text-align:center;"><div><p style="font-size:28px;margin: 0.5em;">${result.today.date}</p>
            <p style="margin-top: 0em;">${result.today.title}</p></div>
            <img src="${result.comment.poster}" referrerpolicy="no-referrer"></img>
            <div><p style="font-size:24px;">《${result.subject.title}》</p></div>
            <div><p style="font-size:24px;">${result.comment.content}</p></div>
            <div><p>${result.subject.card_subtitle}</p></div>
            <div style="font-size:14px;"><p>豆瓣评分：${result.subject.rating.value}
            </p><a target="_blank" href="${result.subject.url}">去豆瓣查看详情</a></div>
            </div>
          `;
          $('.kratos-post-content').append(html);
        }else{
          $('.kratos-post-content').append(`<p>哎呀，豆瓣电影日历崩溃了o(≧口≦)o</p>`);
        }
      },
      error: err => {
        $('.kratos-post-content').append(`<p>哎呀，豆瓣电影日历崩溃了o(≧口≦)o，重新刷新下吧~</p>`);
      }
    })

})();
</script>


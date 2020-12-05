---
title: ONE 每日图文
date: 2020-06-18 12:29:05
type: "one"
toc: false
comments: false
---


<script>
; (function () {
  $('.kratos-post-content > h2').next().remove();
  $.ajax({
    url: 'https://green-cloud-7dfe.vensing.workers.dev/',
    type: 'get',
    dataType: "json"
  })
  .then(result => {
      if (result && result.res === 0) {
        let datas = result.data;
        let html = `<div style="text-align:center;"><div><p style="font-size:28px;margin: 0.5em;">${datas[0].date}</p>
			        <p style="margin-top: 0em;">${datas[0].title}</p></div>
			        <img src="https://ip.webmasterapi.com/api/imageproxy/${datas[0].img_url}" referrerpolicy="no-referrer"></img>
			        <div><p style="font-size:12px;">${datas[0].picture_author}</p></div>
			        <div><p style="font-size:24px;">${datas[0].content}</p></div>
			        <div><p>${datas[0].text_authors}</p></div>
			        <div><a href="http://wufazhuce.com/">ONE | 一个</a></div></div>`;
        $('.kratos-post-content').append(html);
      } else {
        return Promise.reject('Error');
      }
  })
  .catch(() => {
    let html = `<p>哎呀，每日一图崩溃了o(≧口≦)o</p>`;
    $('.kratos-post-content').append(html);
  })

})();
</script>


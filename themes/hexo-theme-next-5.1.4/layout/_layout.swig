<!DOCTYPE html>

{% set html_class = 'theme-next ' + theme.scheme %}
{% if theme.motion.enable %}
  {% set html_class = html_class + ' use-motion' %}
{% endif %}

<html class="{{ html_class | lower }}" lang="{{ config.language }}">
<head>
  {% include '_partials/head.swig' %}
  <title>{% block title %}{% endblock %}</title>
  {% include '_third-party/analytics/index.swig' %}
  
</head>

<body  itemscope itemtype="http://schema.org/WebPage" lang="{{ page.lang || page.language || config.language }}" style="
    background: #fafafa !important;
    background-repeat: repeat-x !important;
    background-image: url(/img/blog-bg.png) !important;">

  
  {% set container_class = "container " %}
  {% if theme.sidebar.position %}
    {% set container_class = container_class + 'sidebar-position-' + theme.sidebar.position %}
  {% endif %}

  <div class="{{ container_class }} {% block page_class %}{% endblock %}">
    <div class="headband"></div>

    <header id="header" class="header" itemscope itemtype="http://schema.org/WPHeader">
      <div class="header-inner"> {%- include '_partials/header.swig' %} </div>
    </header>

    <main id="main" class="main">
      <div class="main-inner">
        <div class="content-wrap">
          <div id="content" class="content">
		  
            {% block content %}{% endblock %}
          </div>
          {% include '_third-party/duoshuo-hot-articles.swig' %}
          {% include '_partials/comments.swig' %}
		  
		  
		  <div class="sidebar-inner affix-top" id="ismobile" style=" position:relative; opacity: 1;display: none;transform: initial; border: dashed 1px lightgray; width: auto;">

      <section class="site-overview-wrap sidebar-panel sidebar-panel-active">
        <div class="site-overview" style="max-height: 593px;">
          <div class="site-author motion-element" itemprop="author" itemscope="" itemtype="http://schema.org/Person" style="opacity: 1;">
            
			{% if theme.avatar %}
              <img class="site-author-image" itemprop="image"
                src="{{ url_for( theme.avatar | default(theme.images + '/avatar.gif') ) }}"
                alt="{{ theme.author }}" />
            {% endif %}
			           
              <p class="site-author-name" itemprop="name">{{ theme.author }}</p>
              <p class="site-description motion-element" style="opacity:1;" itemprop="description">{#
            #}{% if theme.seo %}{#
              #}{{ theme.signature }}{#
            #}{% else %}{#
              #}{{ theme.description }}{#
            #}{% endif %}{#
            #}</p>
          </div>

          <nav class="site-state motion-element" style="opacity:1;">

            
              {% if config.archive_dir != '/' and site.posts.length > 0 %}
              <div class="site-state-item site-state-posts">
              {% if theme.menu.archives %}
                <a href="{{ url_for(theme.menu.archives).split('||')[0] | trim }}">
              {% else %}
                <a href="{{ url_for(config.archive_dir) }}">
              {% endif %}
                  <span class="site-state-item-count">{{ site.posts.length }}</span>
                  <span class="site-state-item-name">{{ __('state.posts') }}</span>
                </a>
              </div>
            {% endif %}

            {% if site.categories.length > 0 %}
              {% set categoriesPageQuery = site.pages.find({type: 'categories'}, {lean: true}) %}
              {% set hasCategoriesPage = categoriesPageQuery.length > 0 %}
              <div class="site-state-item site-state-categories">
                {% if hasCategoriesPage %}<a href="{{ url_for(categoriesPageQuery[0].path) }}">{% endif %}
                  <span class="site-state-item-count">{{ site.categories.length }}</span>
                  <span class="site-state-item-name">{{ __('state.categories') }}</span>
                {% if hasCategoriesPage %}</a>{% endif %}
              </div>
            {% endif %}

            {% if site.tags.length > 0 %}
              {% set tagsPageQuery = site.pages.find({type: 'tags'}, {lean: true}) %}
              {% set hasTagsPage = tagsPageQuery.length > 0 %}
              <div class="site-state-item site-state-tags">
                {% if hasTagsPage %}<a href="{{ url_for(tagsPageQuery[0].path) }}">{% endif %}
                  <span class="site-state-item-count">{{ site.tags.length }}</span>
                  <span class="site-state-item-name">{{ __('state.tags') }}</span>
                {% if hasTagsPage %}</a>{% endif %}
              </div>
            {% endif %}
            

          </nav>

          

			{% if theme.social %}
            <div class="links-of-author motion-element" style="opacity:1;text-align: center;">
                {% for name, link in theme.social %}
                  <span class="links-of-author-item">
                    <a href="{{ link.split('||')[0] | trim }}" target="_blank" title="{{ name }}">
                      {% if theme.social_icons.enable %}
                        <i class="fa fa-fw fa-{{ link.split('||')[1] | trim | default('globe') }}"></i>{#
                    #}{% endif %}{#
                      #}{% if not theme.social_icons.icons_only %}{#
                        #}{{ name }}{#
                      #}{% endif %}{#
                  #}</a>
                  </span>
                {% endfor %}
            </div>
          {% endif %}
          
            
          

          {# Blogroll #}
          {% if theme.links %}
            <div class="links-of-blogroll motion-element {{ "links-of-blogroll-" + theme.links_layout | default('inline') }}" style="opacity:1;">
              <div class="links-of-blogroll-title">
                <i class="fa  fa-fw fa-{{ theme.links_icon | default('globe') | lower }}"></i>
                {{ theme.links_title }}
              </div>
              <ul class="links-of-blogroll-list">
                {% for name, link in theme.links %}
                  <li class="links-of-blogroll-item">
                    <a href="{{ link }}" title="{{ name }}" target="_blank">{{ name }}</a>
                  </li>
                {% endfor %}
              </ul>
            </div>
          {% endif %}
          
            

        </div>
      </section>
    </div>
	
		  
	
	
	
        </div>
		
        {% if theme.sidebar.display !== 'remove' %}
          {% block sidebar %}{% endblock %}
        {% endif %}
		
      </div>
    </main>

    <footer id="footer" class="footer">
      <div class="footer-inner">
        {% include '_partials/footer.swig' %}
        {% include '_third-party/analytics/analytics-with-widget.swig' %}
        {% block footer %}{% endblock %}
      </div>
    </footer>

    {% if not theme.sidebar.b2t %}
      <div class="back-to-top">
        <i class="fa fa-arrow-up"></i>
        {% if theme.sidebar.scrollpercent %}
          <span id="scrollpercent"><span>0</span>%</span>
        {% endif %}
      </div>
    {% endif %}

    {% if theme.needmoreshare2.enable and theme.needmoreshare2.float.enable %}
      <div id="needsharebutton-float">
        <span class="btn">
          <i class="fa fa-share-alt" aria-hidden="true"></i>
        </span>
      </div>
    {% endif %}

  </div>

	  <div id="landlord" style="left:5px;bottom:0px;">

    <div class="message" style="opacity:0"></div>

    <canvas id="live2d" width="500" height="560" class="live2d"></canvas>

    <div class="live_talk_input_body">

        <div class="live_talk_input_name_body">

            <input name="name" type="text" class="live_talk_name white_input" id="AIuserName" autocomplete="off" placeholder="你的名字" />

        </div>

        <div class="live_talk_input_text_body">

            <input name="talk" type="text" class="live_talk_talk white_input" id="AIuserText" autocomplete="off" placeholder="要和我聊什么呀？"/>

            <button type="button" class="live_talk_send_btn" id="talk_send">发送</button>

        </div>

    </div>

    <input name="live_talk" id="live_talk" value="1" type="hidden" />

    <div class="live_ico_box">

        <div class="live_ico_item type_info" id="showInfoBtn"></div>

        <div class="live_ico_item type_talk" id="showTalkBtn"></div>

        <div class="live_ico_item type_huanzhuang" id="huanzhuangButton"></div>

        <div class="live_ico_item type_music" id="musicButton"></div>

        <div class="live_ico_item type_youdu" id="youduButton"></div>

        <div class="live_ico_item type_quit" id="hideButton"></div>

        <input name="live_statu_val" id="live_statu_val" value="0" type="hidden" />

        <audio src="" style="display:none;" id="live2d_bgm" data-bgm="0" preload="none"></audio>

        <input name="live2dBGM" value="https://t1.aixinxi.net/o_1c52p4qbp15idv6bl55h381moha.mp3" type="hidden">

        <input name="live2dBGM" value="https://t1.aixinxi.net/o_1c52p8frrlmf1aled1e14m56una.mp3" type="hidden">

        <input id="duType" value="douqilai,l2d_caihong" type="hidden">

    </div>

</div>

<div id="open_live2d">召唤椎名真白</div>

<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/1.7.1/jquery.min.js"></script>

<script>

var message_Path = '/live2d/';//资源目录，如果目录不对请更改

var talkAPI = "";//如果有类似图灵机器人的聊天接口请填写接口路径

</script>

<script type="text/javascript" src="{{ config.url }}/live2d/js/live2d.js"></script>

<script type="text/javascript" src="{{ config.url }}/live2d/js/message.js"></script>

  {% include '_scripts/vendors.swig' %}
  {% include '_scripts/commons.swig' %}

  {% set scheme_script = '_scripts/schemes/' + theme.scheme | lower + '.swig' %}
  {% include scheme_script %}

  {% block script_extra %}{% endblock %}

  {% include '_scripts/boostrap.swig' %}

  {% include '_third-party/comments/index.swig' %}
  {% include '_third-party/search/index.swig' %}
  {% include '_third-party/analytics/lean-analytics.swig' %}
  {% include '_third-party/analytics/firestore.swig' %}
  {% include '_third-party/seo/baidu-push.swig' %}
  {% include '_third-party/needsharebutton.swig' %}
  {% include '_third-party/rating.swig' %}
  {% include '_third-party/mathjax.swig' %}
  {% include '_third-party/scroll-cookie.swig' %}
  {% include '_third-party/exturl.swig' %}
  
  

  
</body>
</html>
<script>
  window.onload = function IsMobile() {
          var userAgentInfo = navigator.userAgent;
          var Agents = ["Android", "iPhone",
                      "SymbianOS", "Windows Phone",
                      "iPad", "iPod"];
          var flag = false;
          for (var v = 0; v < Agents.length; v++) {
              if (userAgentInfo.indexOf(Agents[v]) > 0) {
                  flag = true;
                 break;
             }
        }
         if(!flag){
			var sidebardom = document.getElementById("ismobile");
				if(sidebardom!=null){
					sidebardom.parentNode.removeChild(sidebardom);
				}
			}else{
			if(sidebardom){
				sidebardom.style.display = "block";
				}
			}
     }
	
  </script>

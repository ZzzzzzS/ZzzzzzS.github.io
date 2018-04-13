<div class="error-page" style="background-image: url('{{ get_setting('error_page_bg') }}')">
    <div class="error-page__container">
        <div class="error-page__main">
            <h1 class="error-page__title">404</h1>
            <h2 class="error-page__subtitle">啊,你要找的页面消失了</h2>
            <p class="error-page__text">
                一定是发生了什么可怕的事情
            </p>
            <ul class="social-network clearfix">
                {% for item in site.data.contact %}
                    {% if item.title != 'rss' %}
                        <li class="social-network__item">
                            <a href="{{ item.link }}" target="_blank" title="{{ item.title }}">
                                <i class="iconfont {{ item.icon }}"></i>
                            </a>
                        </li>
                    {% endif %}
                {% endfor %}
            </ul>
        </div>
    </div>
</div>
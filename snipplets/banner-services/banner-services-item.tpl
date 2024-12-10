<div class="service-item-container col-md swiper-slide p-0 px-md-3 js-informative-banner-container" {% if not banner_show %}style="display: none"{% endif %}>
    <div class="service-item mx-4 mx-md-0">
        {% if banner_services_url %}
            <a href="{{ banner_services_url | setting_url }}">
        {% endif %}
        <div class="row align-items-center">
            <div class="col-auto js-informative-banner-icon-{{ banner_index }}">
                {% if banner_services_icon == 'shipping' %}
                    <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#shipping-circle"/></svg>
                {% elseif banner_services_icon == 'card' %}
                    <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#credit-card-circle"/></svg>
                {% elseif banner_services_icon == 'security' %}
                    <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#security-circle"/></svg>
                {% elseif banner_services_icon == 'returns' %}
                    <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#returns-circle"/></svg>
                {% elseif banner_services_icon == 'whatsapp' %}
                    <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#whatsapp-circle"/></svg>
                {% elseif banner_services_icon == 'promotions' %}
                    <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#promotions-circle"/></svg>
                {% elseif banner_services_icon == 'hand' %}
                    <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#clean-hands-circle"/></svg>
                {% elseif banner_services_icon == 'home' %}
                    <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#stay-home-circle"/></svg>
                {% elseif banner_services_icon == 'office' %}
                    <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#home-office-circle"/></svg>
                {% elseif banner_services_icon == 'cash' %}
                    {% if store.country == 'BR' %}
                        <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#barcode-circle"/></svg>
                    {% else %}
                        <svg class="icon-inline icon-5x svg-icon-text"><use xlink:href="#cash-circle"/></svg>
                    {% endif %}
                {% endif %}
            </div>
            <div class="col p-0">
                <h3 class="h5 m-0 js-informative-banner-title js-informative-banner-title-{{ banner_index }}">{{ banner_services_title }}</h3>
                <p class="m-0 js-informative-banner-description-{{ banner_index }}">{{ banner_services_description }}</p>
            </div>
        </div>
        {% if banner_services_url %}
            </a>
        {% endif %}
    </div>
</div>

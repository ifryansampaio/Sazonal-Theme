{# /*============================================================================
  #Item grid
==============================================================================*/

#Properties

#Slide Item

#}

{% set empty_placeholder_image = 'images/empty-placeholder.png' | static_url %}

{% set slide_item = slide_item | default(false) %}
{% set columns = settings.grid_columns %}

{% if slide_item %}
    <div class="swiper-slide{% if settings.theme_rounded %} p-3{% endif %}">
{% endif %}

{% set grid_classes = columns == 1 ? 'col-12 col-md-6 col-lg-4' : 'col-6 col-md-4 col-lg-3' %}
{% if settings.theme_rounded %}
    <div class="js-item-product {% if highlighted_products_setting_name %}js-products-{{ highlighted_products_setting_name }}-product{% endif %} {% if not slide_item %}{{ grid_classes }}{% endif %}" data-product-type="list" data-product-id="{{ product.id }}" data-store="product-item-{{ product.id }}" data-component="product-list-item" data-component-value="{{ product.id }}" data-grid-classes="{{ grid_classes }}">
        <div class="item item-rounded item-product box-rounded p-0">
{% else %}
    <div class="js-item-product {% if highlighted_products_setting_name %}js-products-{{ highlighted_products_setting_name }}-product{% endif %} {% if not slide_item %}{{ grid_classes }}{% endif %} item item-product" data-product-type="list" data-product-id="{{ product.id }}" data-store="product-item-{{ product.id }}" data-component="product-list-item" data-component-value="{{ product.id }}" data-grid-classes="{{ grid_classes }}">
{% endif %}
        {% if settings.quick_shop or settings.product_color_variants %}
            <div id="quick{{ product.id }}{% if slide_item and section_name %}-{{ section_name }}{% endif %}" class="js-product-container js-quickshop-container position-relative {% if product.variations %}js-quickshop-has-variants{% endif %}" data-variants="{{ product.variants_object | json_encode }}">
        {% endif %}
        {% set product_url_with_selected_variant = has_filters ?  ( product.url | add_param('variant', product.selected_or_first_available_variant.id)) : product.url  %}

        {% set item_img_width = product.featured_image.dimensions['width'] %}
        {% set item_img_height = product.featured_image.dimensions['height'] %}
        {% set item_img_srcset = product.featured_image %}
        {% set item_img_alt = product.featured_image.alt %}
        {% set item_img_spacing = item_img_height / item_img_width * 100 %}
        {% set show_secondary_image = settings.product_hover and product.other_images %}

        <div class="{% if show_secondary_image %}js-item-with-secondary-image{% endif %} item-image{% if columns == 1 %} item-image-big{% endif %}">
            <div style="padding-bottom: {{ item_img_spacing }}%;" class="position-relative" data-store="product-item-image-{{ product.id }}">
                <a href="{{ product_url_with_selected_variant }}" title="{{ product.name }}" aria-label="{{ product.name }}" >
                    <img alt="{{ item_img_alt }}" data-expand="-10" src="{{ empty_placeholder_image }}" data-srcset="{{ item_img_srcset | product_image_url('small')}} 240w, {{ item_img_srcset | product_image_url('medium')}} 320w, {{ item_img_srcset | product_image_url('large')}} 480w" class="js-item-image lazyautosizes lazyload img-absolute img-absolute-centered fade-in {% if show_secondary_image %}item-image-primary{% endif %}" width="{{ item_img_width }}" height="{{ item_img_height }}" /> 
                    <div class="placeholder-fade">
                    </div>

                    {% if show_secondary_image %}
                        {% set secondary_image = product.other_images | first %}
                        <img alt="{{ item_img_alt }}" data-sizes="auto" src="{{ empty_placeholder_image }}" data-srcset="{{ secondary_image | product_image_url('small')}} 240w, {{ secondary_image | product_image_url('medium')}} 320w, {{ secondary_image | product_image_url('large')}} 480w" class="js-item-image js-item-image-secondary lazyautosizes lazyload img-absolute img-absolute-centered fade-in item-image-secondary" style="display:none;" />
                    {% endif %}
                </a>
            </div>
            {% if settings.product_color_variants %}
                {% include 'snipplets/labels.tpl' with {color: true} %}
                {% include 'snipplets/grid/item-colors.tpl' %}
            {% else %}
                {% include 'snipplets/labels.tpl' %}
            {% endif %}
            {% if (settings.quick_shop or settings.product_color_variants) and product.available and product.display_price and product.variations %}
                <div class="item-buy{% if settings.product_color_variants and not settings.quick_shop %} hidden{% endif %}">
                    <div class="js-item-variants item-buy-variants{% if settings.theme_rounded %} px-1 py-2 p-md-3{% endif %}">
                        <form class="js-product-form" method="post" action="{{ store.cart_url }}">
                            <input type="hidden" name="add_to_cart" value="{{product.id}}" />
                            {% if product.variations %}
                                {% include "snipplets/product/product-variants.tpl" with {quickshop: true} %}
                            {% endif %}
                            {% set state = store.is_catalog ? 'catalog' : (product.available ? product.display_price ? 'cart' : 'contact' : 'nostock') %}
                            {% set texts = {'cart': "Agregar al carrito", 'contact': "Consultar precio", 'nostock': "Sin stock", 'catalog': "Consultar"} %}

                            {# Add to cart CTA #}

                            <input type="submit" class="js-addtocart js-prod-submit-form btn btn-primary btn-small w-100 mb-2 {{ state }}" value="{{ texts[state] | translate }}" {% if state == 'nostock' %}disabled{% endif %} />

                            {# Fake add to cart CTA visible during add to cart event #}

                            {% include 'snipplets/placeholders/button-placeholder.tpl' with {custom_class: "btn-small w-100 mb-2"} %}
                        </form>
                        <a href="#" class="js-item-buy-close">
                            <svg class="icon-inline icon-lg svg-circle svg-icon-text"><use xlink:href="#times"/></svg>
                        </a>
                    </div>
                </div>
            {% endif %}
        </div>
        <div class="item-description py-4{% if settings.theme_rounded %} px-3{% else %} px-1{% endif %}" data-store="product-item-info-{{ product.id }}">
            <a href="{{ product_url_with_selected_variant }}" title="{{ product.name }}" aria-label="{{ product.name }}" class="item-link">
                <div class="js-item-name item-name mb-3" data-store="product-item-name-{{ product.id }}">{{ product.name }}</div>
                {% if product.display_price %}
                    <div class="item-price-container mb-1" data-store="product-item-price-{{ product.id }}">
                        <span class="js-compare-price-display price-compare" {% if not product.compare_at_price or not product.display_price %}style="display:none;"{% else %}style="display:inline-block;"{% endif %}>
                            {{ product.compare_at_price | money }}
                        </span>
                        <span class="js-price-display item-price" data-product-price="{{ product.price }}">
                            {{ product.price | money }}
                        </span>
                    </div>
                {% endif %}
            </a>

            {% set product_can_show_installments = product.show_installments and product.display_price and product.get_max_installments.installment > 1 and settings.product_installments %}

            {% set discount_price_spacing_classes = product_can_show_installments ? 'mt-1 mb-2' %}

            {{ component('payment-discount-price', {
                    visibility_condition: settings.payment_discount_price,
                    location: 'product',
                    container_classes: discount_price_spacing_classes ~ " font-small font-md-normal text-accent font-weight-bold",
                }) 
            }}

            {% if product_can_show_installments %}
                {{ component('installments', {'location' : 'product_item', container_classes: { installment: "item-installments"}}) }}
            {% endif %}
        </div>
        {% if settings.quick_shop %}
            <div class="item-actions row justify-content-center{% if settings.theme_rounded %} m-0 mb-3{% endif %}">
                {% if product.available and product.display_price %}
                    <div class="col-8 col-md-6 pr-1">
                        {% if product.variations %}
                            <a href="#" class="js-item-buy-open item-buy-open d-block btn btn-primary btn-small" title="{{ 'Compra rápida de' | translate }} {{ product.name }}" aria-label="{{ 'Compra rápida de' | translate }} {{ product.name }}" data-component="product-list-item.add-to-cart" data-component-value="{{product.id}}">{{ 'Comprar' | translate }}</a>
                        {% else %}
                            <form class="js-product-form" method="post" action="{{ store.cart_url }}">
                                <input type="hidden" name="add_to_cart" value="{{product.id}}" />
                                {% set state = store.is_catalog ? 'catalog' : (product.available ? product.display_price ? 'cart' : 'contact' : 'nostock') %}
                                {% set texts = {'cart': "Comprar", 'contact': "Consultar precio", 'nostock': "Sin stock", 'catalog': "Consultar"} %}

                                <input type="submit" class="js-addtocart js-prod-submit-form btn btn-primary btn-small w-100 mb-2 {{ state }}" value="{{ texts[state] | translate }}" {% if state == 'nostock' %}disabled{% endif %} data-component="product-list-item.add-to-cart" data-component-value="{{ product.id }}"/>

                                {# Fake add to cart CTA visible during add to cart event #}

                                {% include 'snipplets/placeholders/button-placeholder.tpl' with {custom_class: "btn-small w-100 mb-2", direct_add: true} %}
                            </form>
                        {% endif %}
                    </div>
                {% endif %}
                <div class="{% if product.available and product.display_price %}col-4 col-md-6 pl-1{% else %}col-12 col-md-6{% endif %}">
                    <a href="{{ product.url }}" title="{{ product.name }}" aria-label="{{ product.name }}" class="d-block btn btn-secondary btn-small">
                        <svg class="icon-inline svg-icon-primary icon-w-19"><use xlink:href="#eye"/></svg>
                        <span class="{% if product.available and product.display_price %}d-none d-md-inline-block{% endif %}">{{ "Ver" | translate }}</span></a>
                </div>
            </div>
        {% endif %}
        {% if settings.quick_shop or settings.product_color_variants %}
            </div>{# This closes the quickshop tag #}
        {% endif %}

        {# Structured data to provide information for Google about the product content #}
        {{ component('structured-data', {'item': true}) }}
    </div>
{% if settings.theme_rounded %}
    </div>
{% endif %}
{% if slide_item %}
    </div>
{% endif %}

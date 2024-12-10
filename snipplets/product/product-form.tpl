{# Product name and breadcrumbs #}

{% embed "snipplets/page-header.tpl" %}
	{% block page_header_text %}{{ product.name }}{% endblock page_header_text %}
{% endembed %}

{# Product price #}

<div class="price-container mb-4" data-store="product-price-{{ product.id }}">
    <span class="d-inline-block">
	   <h4 id="compare_price_display" class="js-compare-price-display price-compare font-weight-normal mb-0" {% if not product.compare_at_price or not product.display_price %}style="display:none;"{% else %} style="display:block;"{% endif %}>{% if product.compare_at_price and product.display_price %}{{ product.compare_at_price | money }}{% endif %}</h4>
    </span>
    <span class="d-inline-block">
    	<h2 class="js-price-display text-primary mb-0" id="price_display" {% if not product.display_price %}style="display:none;"{% endif %} data-product-price="{{ product.price }}">{% if product.display_price %}{{ product.price | money }}{% endif %}</h2>
    </span>

    {{ component('payment-discount-price', {
            visibility_condition: settings.payment_discount_price,
            location: 'product',
            container_classes: "h4 text-accent font-weight-bold mt-1",
        })
    }}

    {% set show_compare_price_saved_amount = not (settings.payment_discount_price and max_payment_discount.value > 0) and settings.compare_price_saved_money %}

    {{ component('compare-price-saved-amount', {
            visibility_condition: show_compare_price_saved_amount,
            discount_percentage_wording: 'OFF',
            container_classes: "d-flex align-items-center mt-2",
            text_classes: {
                amount_message_container: 'd-inline-block',
                amount_message: 'font-small',
            },
            discount_percentage_classes: 'ml-2 label label-small label-accent m-0',
        })
    }}
</div>

{# Promotional text #}

{% if product.promotional_offer and not product.promotional_offer.script.is_percentage_off and product.display_price %}
    <div class="js-product-promo-container mb-4" data-store="product-promotion-info">
        {% if product.promotional_offer.script.is_discount_for_quantity %}
            {% if product.promotional_offer.parameters | length > 1 %}
                {{ component('progressive-discounts-table', {
                    progressive_discounts_classes: {
                        title: 'text-accent mb-3',
                        hidden_table: 'table-body-inverted',
                        table: 'table mb-2',
                        show_more_link: 'btn-link btn-link-primary mb-4',
                        show_more_icon: 'icon-inline',
                        hide_icon: 'icon-inline icon-flip-vertical',
                        promotion_quantity: 'font-weight-light text-lowercase'
                    },
                    accordion_show_svg_id: 'chevron-down',
                    accordion_hide_svg_id: 'chevron-down',
                }) }}
            {% else %}
                {% set threshold = product.promotional_offer.parameters[0] %}
                <h4 class="mb-2 text-accent"><strong>{{ "¡{1}% OFF comprando {2} o más!" | translate(threshold.discount_decimal_percentage * 100, threshold.quantity) }}</strong></h4>
            {% endif %}
        {% else %}
            <h4 class="mb-2 text-accent"><strong>{{ "¡Llevá {1} y pagá {2}!" | translate(product.promotional_offer.script.quantity_to_take, product.promotional_offer.script.quantity_to_pay) }}</strong></h4>
        {% endif %}
        {% if product.promotional_offer.scope_type == 'categories' %}
            <p class="mb-0">{{ "Válido para" | translate }} {{ "este producto y todos los de la categoría" | translate }}:
            {% for scope_value in product.promotional_offer.scope_value_info %}
               {{ scope_value.name }}{% if not loop.last %}, {% else %}.{% endif %}
            {% endfor %}</br>{{ "Podés combinar esta promoción con otros productos de la misma categoría." | translate }}</p>
        {% elseif product.promotional_offer.scope_type == 'all'  %}
            <p class="mb-0">{{ "Vas a poder aprovechar esta promoción en cualquier producto de la tienda." | translate }}</p>
        {% endif %}
        {% if not product.promotional_offer.combines_with_other_discounts  %}
            <p class="font-small opacity-60 mt-1 mb-0">{{ "No acumulable con otras promociones" | translate }}</p>
        {% endif %}
    </div>
{% endif %}

{# Product installments #}

{% set installments_info = product.installments_info_from_any_variant %}
{% set hasDiscount = product.maxPaymentDiscount.value > 0 %}
{% set show_payments_info = settings.product_detail_installments and product.show_installments and product.display_price and installments_info %}

{% if show_payments_info or hasDiscount %}
    <div data-toggle="#installments-modal" data-modal-url="modal-fullscreen-payments" class="js-modal-open js-fullscreen-modal-open js-product-payments-container row mb-4" {% if not (product.get_max_installments and product.get_max_installments(false)) %}style="display: none;"{% endif %}>

        {% if show_payments_info %}
            {% set max_installments_without_interests = product.get_max_installments(false) %}
            {% set installments_without_interests = max_installments_without_interests and max_installments_without_interests.installment > 1 %}
            {% set card_icon_color = installments_without_interests ? 'svg-icon-accent' : 'svg-icon-text' %}

            <div class="col-12 mb-2">
                <span class="float-left mr-2">
                    <svg class="icon-inline icon-lg {{ card_icon_color }}"><use xlink:href="#credit-card"/></svg>
                </span>
                {{ component('installments', {'location' : 'product_detail', container_classes: { installment: "product-detail-installments d-table"}}) }}
            </div>
        {% endif %}

        {% set discountContainerStyle = not (hasDiscount and product.showMaxPaymentDiscount) ? "display: none" %}
        <div class="js-product-discount-container w-100" style="{{ discountContainerStyle }}">
            <div class="col-12 mb-2 d-flex">
                <span class="mr-2">
                    <svg class="icon-inline svg-icon-accent icon-lg"><use xlink:href="#money-bill"/></svg>
                </span>
                <span>
                    <div><strong class="text-accent">{{ product.maxPaymentDiscount.value }}% {{'de descuento' | translate }}</strong> {{'pagando con' | translate }} {{ product.maxPaymentDiscount.paymentProviderName }}</div>
                    {% set discountDisclaimerStyle = not product.showMaxPaymentDiscountNotCombinableDisclaimer ? "display: none" %}
                    <div class="js-product-discount-disclaimer font-small opacity-60 mt-1" style="{{ discountDisclaimerStyle }}">{{ "No acumulable con otras promociones" | translate }}</div>
                </span>
            </div>
        </div>
        <a id="btn-installments" class="btn-link btn-link-primary font-small col mt-1" {% if not (product.get_max_installments and product.get_max_installments(false)) %}style="display: none;"{% endif %}>
            <span class="d-table">
                {% if not hasDiscount and not settings.product_detail_installments %}
                    <svg class="icon-inline icon-lg svg-icon-primary mr-1"><use xlink:href="#credit-card"/></svg>
                    {{ "Ver medios de pago" | translate }}
                {% else %}
                    {{ "Ver más detalles" | translate }}
                {% endif %}
            </span>
        </a>
    </div>
{% endif %}

{# Product availability #}

{% set show_product_quantity = product.available and product.display_price %}

{# Free shipping minimum message #}

{% set has_free_shipping = cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price %}
{% set has_product_free_shipping = product.free_shipping %}

{% if not product.is_non_shippable and show_product_quantity and (has_free_shipping or has_product_free_shipping) %}
    <div class="free-shipping-message mb-4">
        <span class="float-left mr-2">
            <svg class="icon-inline svg-icon-accent icon-lg"><use xlink:href="#truck"/></svg>
        </span>
        <span>
            <strong class="text-accent">{{ "Envío gratis" | translate }}</strong>
            <span {% if has_product_free_shipping %}style="display: none;"{% else %}class="js-shipping-minimum-label"{% endif %}>
                {{ "superando los" | translate }} <span>{{ cart.free_shipping.min_price_free_shipping.min_price }}</span>
            </span>
        </span>
        {% if not has_product_free_shipping %}
            <div class="js-free-shipping-discount-not-combinable font-small opacity-60 mt-1">
                {{ "No acumulable con otras promociones" | translate }}
            </div>
        {% endif %}
    </div>
{% endif %}

{# Product form, includes: Variants, CTA and Shipping calculator #}

 <form id="product_form" class="js-product-form" method="post" action="{{ store.cart_url }}" data-store="product-form-{{ product.id }}">
	<input type="hidden" name="add_to_cart" value="{{product.id}}" />
 	{% if product.variations %}
        {% include "snipplets/product/product-variants.tpl" with {show_size_guide: true} %}
    {% endif %}

    {% if settings.last_product and show_product_quantity %}
        <div class="{% if product.variations %}js-last-product {% endif %}text-accent font-weight-bold mb-4"{% if product.selected_or_first_available_variant.stock != 1 %} style="display: none;"{% endif %}>
            {{ settings.last_product_text }}
        </div>
        {% if settings.latest_products_available %}
            {% set latest_products_limit = settings.latest_products_available %}
            <div class="{% if product.variations %}js-latest-products-available {% endif %}text-accent font-weight-bold mb-4" data-limit="{{ latest_products_limit }}" {% if product.selected_or_first_available_variant.stock > latest_products_limit or product.selected_or_first_available_variant.stock == null or product.selected_or_first_available_variant.stock == 1 %} style="display: none;"{% endif %}>
                {{ "¡Solo quedan" | translate }} <span class="js-product-stock">{{ product.selected_or_first_available_variant.stock }}</span> {{ "en stock!" | translate }}
            </div>
        {% endif %}
    {% endif %}

    <div class="form-row mb-2">
        {% if show_product_quantity %}
            {% include "snipplets/product/product-quantity.tpl" %}
        {% endif %}
        {% set state = store.is_catalog ? 'catalog' : (product.available ? product.display_price ? 'cart' : 'contact' : 'nostock') %}
        {% set texts = {'cart': "Agregar al carrito", 'contact': "Consultar precio", 'nostock': "Sin stock", 'catalog': "Consultar"} %}
        <div class="col-8 pr-0">

            {# Add to cart CTA #}

            <input type="submit" class="js-addtocart js-prod-submit-form btn btn-primary btn-block mb-4 {{ state }}" value="{{ texts[state] | translate }}" {% if state == 'nostock' %}disabled{% endif %} data-store="product-buy-button" data-component="product.add-to-cart"/>

            {# Fake add to cart CTA visible during add to cart event #}

            {% include 'snipplets/placeholders/button-placeholder.tpl' with {custom_class: "mb-4"} %}

        </div>

        {% if settings.ajax_cart %}
            <div class="col-12">
                <div class="js-added-to-cart-product-message mb-4" style="display: none;">
                    <svg class="icon-inline svg-icon-text mr-2 d-table float-left"><use xlink:href="#check-double"/></svg>
                    <span class="d-table">
                        {{'Ya agregaste este producto.' | translate }}<a href="#" class="js-modal-open js-fullscreen-modal-open btn btn-link ml-1 text-primary" data-toggle="#modal-cart" data-modal-url="modal-fullscreen-cart">{{ 'Ver carrito' | translate }}</a>
                    </span>
                </div>
            </div>
        {% endif %}
    </div>

    {# Free shipping visibility message #}

    {% set free_shipping_minimum_label_changes_visibility = has_free_shipping and cart.free_shipping.min_price_free_shipping.min_price_raw > 0 %}

    {% set include_product_free_shipping_min_wording = cart.free_shipping.min_price_free_shipping.min_price_raw > 0 %}

    {% if not product.is_non_shippable and show_product_quantity and has_free_shipping and not has_product_free_shipping %}

        {# Free shipping add to cart message #}

        {% if include_product_free_shipping_min_wording %}

            {% include "snipplets/shipping/shipping-free-rest.tpl" with {'product_detail': true} %}

        {% endif %}

        {# Free shipping achieved message #}

        <div class="{% if free_shipping_minimum_label_changes_visibility %}js-free-shipping-message{% endif %} text-accent font-weight-bold mb-4" {% if not cart.free_shipping.cart_has_free_shipping %}style="display: none;"{% endif %}>
            {{ "¡Genial! Tenés envío gratis" | translate }}
        </div>

    {% endif %}

    {# Define contitions to show shipping calculator and store branches on product page #}

    {% set show_product_fulfillment = settings.shipping_calculator_product_page and (store.has_shipping or store.branches) and not product.free_shipping and not product.is_non_shippable %}

    {% if show_product_fulfillment %}

        {# Shipping calculator and branch link #}

        <div id="product-shipping-container" class="product-shipping-calculator list" {% if not product.display_price or not product.has_stock %}style="display:none;"{% endif %} data-shipping-url="{{ store.shipping_calculator_url }}">

            {% if store.has_shipping %}
                {% include "snipplets/shipping/shipping-calculator.tpl" with {'shipping_calculator_variant' : product.selected_or_first_available_variant, 'product_detail': true} %}
            {% endif %}
            {% if store.branches %}

                {# Link for branches #}
                {% include "snipplets/shipping/branches.tpl" with {'product_detail': true} %}
            {% endif %}
        </div>
    {% endif %}

    {# Product informative banners #}

    {% include 'snipplets/product/product-informative-banner.tpl' %}
 </form>

{# Product payments details #}

{% include 'snipplets/product/product-payment-details.tpl' %}


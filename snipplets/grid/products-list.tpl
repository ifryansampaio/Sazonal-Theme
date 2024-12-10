{% set no_results_message = template == 'category' ? (has_filters_enabled ? "No tenemos resultados para tu búsqueda. Por favor, intentá con otros filtros." : "Próximamente") | translate : "No hubo resultados para tu búsqueda" | translate %}
{% if products %}
    <div class="js-product-table row">
        {% include 'snipplets/product_grid.tpl' %}
    </div>
    {% if pages.current == 1 and not pages.is_last %}
        <div class="text-center mt-5 mb-5">
            <a class="js-load-more btn btn-primary">
                <span class="js-load-more-spinner pull-left m-right-quarter" style="display:none;">
                    <svg class="icon-inline icon-spin"><use xlink:href="#circle-notch"/></svg>
                </span>
                {{ 'Mostrar más productos' | t }}
            </a>
        </div>
        <div id="js-infinite-scroll-spinner" class="mt-5 mb-5 text-center w-100" style="display:none">
            <svg class="icon-inline icon-3x svg-icon-text icon-spin"><use xlink:href="#circle-notch"/></svg>
        </div>
    {% endif %}
{% else %}
    <h6 class="text-center my-2" data-component="filter.message">
        {{ no_results_message }}
    </h6>
{% endif %}
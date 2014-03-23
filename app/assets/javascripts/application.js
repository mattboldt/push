// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require ace/ace
//= require ace/theme-twilight.js
//= require ace/mode-markdown.js
//= require_tree .

$(document).on("ready page:load", function() {
    $(".user-nav-wrap .nav-expand").click(function(e) {
        e.stopPropagation();
        if ($(this).data("status") === "active") {
            $(".user-nav").removeClass("nav--active");
            $(this).data("status", "inactive");
        } else {
            $(".user-nav").addClass("nav--active");
            $(this).data("status", "active");
        }
    });
    $(".user-nav-wrap").click(function(e) {
        e.stopPropagation();
    });
    $(document.body).click(function(e) {
        $(".user-nav").removeClass("nav--active");
        $(".user-nav-wrap .nav-expand").data("status", "inactive");
    });

    $("a[href=#]").click(function(e){
        e.preventDefault();
    });


    var snippets = $(".highlight");
    $.each(snippets, function(x, y){
        $(y).append("<a class=\"code-select\" href=\"#\">select</a>");
    });

    $(".code-select").click(function(e){
        e.preventDefault();
        $(this).parent(".highlight").find("pre").selectText();
    });


});

jQuery.fn.selectText = function(){
    var doc = document
        , element = this[0]
        , range, selection
    ;
    if (doc.body.createTextRange) {
        range = document.body.createTextRange();
        range.moveToElementText(element);
        range.select();
    } else if (window.getSelection) {
        selection = window.getSelection();
        range = document.createRange();
        range.selectNodeContents(element);
        selection.removeAllRanges();
        selection.addRange(range);
    }
};
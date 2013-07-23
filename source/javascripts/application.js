//= require_self
//= require ./vendor/jquery.scrollTo
//= require ./vendor/jquery.localscroll
//= require_tree ./vendor
//= require_tree ./particle

$(function() {
  $.localScroll({
    offset: {
      top:-70
    },
    duration: 100
  });
  var titles = $('.documentation-body h2, .documentation-body h1');

  titles.each(function() {
    var $el = $(this);
    var title = $el.text();
    var anchorName = title
                        .replace(/[^a-z0-9\-_]+/gi, "-")
                        .replace(/\-+/, '-')
                        .replace(/\-$/, '')
                        .toLowerCase();
    var anchor = $("<a/>")
    anchor.addClass('documentation-anchor');
    anchor.attr("name", anchorName);
    anchor.attr("href", "#" + anchorName);
    anchor.html("&infin;");
    $el.prepend(anchor);
  });

  var currentHash = document.location.hash;
  if (currentHash) {
    var anchor = $('a.documentation-anchor[name="' + currentHash.substring(1) + '"]'); 
  }

  function offCanvas(el) {
    $(el).on('click', function() {
      console.log(el);
      $(el).parents('header').toggleClass('active');
    });
  }
  offCanvas('#toggle');

});
(function() {
  var applyExtra;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  applyExtra = function(Batman) {
    var translationsAlias;
    Batman.I18N = (function() {

      __extends(I18N, Batman.Object);

      I18N.defaultLocale = "en";

      I18N.classAccessor('locale', {
        get: function() {
          return this.locale || this.get('defaultLocale');
        },
        set: function(k, v) {
          return this.locale = v;
        },
        unset: function() {
          var x;
          x = this.locale;
          delete this.locale;
          return x;
        }
      });

      I18N.classAccessor('translations', function() {
        return this.get("locales." + (this.get('locale')));
      });

      I18N.translate = function(key, values) {
        var translation;
        translation = this.get("translations." + key);
        if (!(translation != null)) {
          Batman.developer.warn("Warning, undefined translation " + key + " when in local " + (this.get('locale')));
          return "";
        }
        return Batman.helpers.interpolate(translation, values);
      };

      I18N.enable = function() {
        var _this = this;
        this._oldTranslation = Batman.translate;
        this.locales.set('en', Batman.translate.messages);
        return Batman.translate = function() {
          return _this.translate.apply(_this, arguments);
        };
      };

      I18N.disable = function() {
        return Batman.translate = this._oldTranslation;
      };

      function I18N() {
        developer.error("Can't instantiate i18n!");
      }

      return I18N;

    })();
    Batman.I18N.LocalesStorage = (function() {

      __extends(LocalesStorage, Batman.Object);

      function LocalesStorage() {
        this.isStorage = true;
        this._storage = {};
        LocalesStorage.__super__.constructor.apply(this, arguments);
      }

      LocalesStorage.accessor({
        get: function(k) {
          var _this = this;
          if (!this._storage[k]) {
            this._storage[k] = {};
            new Batman.Request({
              url: "/locales/" + k + ".json",
              success: function(data) {
                return _this.set(k, data[k]);
              },
              error: function(xhr) {
                throw new Error("Couldn't load locale file " + k + "!");
              }
            });
          }
          return this._storage[k];
        },
        set: function(k, v) {
          return this._storage[k] = v;
        },
        unset: function(k) {
          var x;
          x = this._storage[k];
          delete this._storage[k];
          return x;
        }
      });

      return LocalesStorage;

    })();
    Batman.I18N.set('locales', new Batman.I18N.LocalesStorage);
    Batman.Filters.t = Batman.Filters.translate = Batman.Filters.interpolate;
    translationsAlias = Batman();
    translationsAlias.accessor('t', function() {
      return Batman.I18N.get('translations');
    });
    return Batman.RenderContext.base = Batman.RenderContext.base.descend(translationsAlias);
  };

  if ((typeof module !== "undefined" && module !== null) && (typeof require !== "undefined" && require !== null)) {
    module.exports = applyExtra;
  } else {
    applyExtra(Batman);
  }

}).call(this);

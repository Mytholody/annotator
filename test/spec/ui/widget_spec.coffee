var $, UI;

$ = require('../../../src/util').$;

UI = require('../../../src/ui');

describe("UI.Widget", function() {
    var widget;
    widget = null;
    beforeEach(function() {
        return widget = new UI.Widget();
    });
    describe("constructor", function() {
        return it("should extend the Widget#classes object with child classes", function() {
            var ChildWidget, child;
            ChildWidget = UI.Widget.extend({});
            ChildWidget.classes = {
                customClass: 'my-custom-class',
                anotherClass: 'another-class'
            };
            child = new ChildWidget();
            return assert.deepEqual(child.classes, {
                hide: 'annotator-hide',
                invert: {
                    x: 'annotator-invert-x',
                    y: 'annotator-invert-y'
                },
                customClass: 'my-custom-class',
                anotherClass: 'another-class'
            });
        });
    });
    describe("invertX", function() {
        return it("should add the Widget#classes.invert.x class to the Widget#widget", function() {
            widget.element.removeClass(widget.classes.invert.x);
            widget.invertX();
            return assert.isTrue(widget.element.hasClass(widget.classes.invert.x));
        });
    });
    describe("invertY", function() {
        return it("should add the Widget#classes.invert.y class to the Widget#widget", function() {
            widget.element.removeClass(widget.classes.invert.y);
            widget.invertY();
            return assert.isTrue(widget.element.hasClass(widget.classes.invert.y));
        });
    });
    describe("isInvertedY", function() {
        return it("should return the vertical inverted status of the Widget", function() {
            assert.isFalse(widget.isInvertedY());
            widget.invertY();
            return assert.isTrue(widget.isInvertedY());
        });
    });
    describe("isInvertedX", function() {
        return it("should return the horizontal inverted status of the Widget", function() {
            assert.isFalse(widget.isInvertedX());
            widget.invertX();
            return assert.isTrue(widget.isInvertedX());
        });
    });
    describe("resetOrientation", function() {
        return it("should remove the Widget#classes.invert classes from the Widget#widget", function() {
            widget.element.addClass(widget.classes.invert.x).addClass(widget.classes.invert.y);
            widget.resetOrientation();
            assert.isFalse(widget.element.hasClass(widget.classes.invert.x));
            return assert.isFalse(widget.element.hasClass(widget.classes.invert.y));
        });
    });
    return describe("checkOrientation", function() {
        var mocks;
        mocks = [
            // Fits in viewport
            {
                window: { width: 920, scrollTop: 0, scrollLeft: 0 },
                element: { offset: { top: 300, left: 0 }, width: 250 }
            },
            // Hidden to the right
            {
                window: { width: 920, scrollTop: 0, scrollLeft: 0 },
                element: { offset: { top: 200, left: 900 }, width: 250 }
            },
            // Hidden to the top
            {
                window: { width: 920, scrollTop: 0, scrollLeft: 0 },
                element: { offset: { top: -100, left: 0 }, width: 250 }
            },
            // Hidden to the top and right
            {
                window: { width: 920, scrollTop: 0, scrollLeft: 0 },
                element: { offset: { top: -100, left: 900 }, width: 250 }
            },
            // Hidden at the top due to scrolling Y
            {
                window: { width: 920, scrollTop: 300, scrollLeft: 0 },
                element: { offset: { top: 200, left: 0 }, width: 250 }
            },
            // Visible to the right due to scrolling X
            {
                window: { width: 750, scrollTop: 0, scrollLeft: 300 },
                element: { offset: { top: 200, left: 750 }, width: 250 }
            }
        ];
        beforeEach(function() {
            var element, window, _ref;
            _ref = mocks.shift(), window = _ref.window, element = _ref.element;
            sinon.stub($.fn, 'init').returns({
                width: sinon.stub().returns(window.width),
                scrollTop: sinon.stub().returns(window.scrollTop),
                scrollLeft: sinon.stub().returns(window.scrollLeft)
            });
            sinon.stub(widget.element, 'children').returns({
                offset: sinon.stub().returns(element.offset),
                width: sinon.stub().returns(element.width)
            });
            sinon.stub(widget, 'invertX');
            sinon.stub(widget, 'invertY');
            sinon.stub(widget, 'resetOrientation');
            return widget.checkOrientation();
        });
        afterEach(function() {
            widget.element.children.restore();
            return $.fn.init.restore();
        });
        it("should reset the widget each time", function() {
            assert(widget.resetOrientation.calledOnce);
            assert.isFalse(widget.invertX.called);
            return assert.isFalse(widget.invertY.called);
        });
        it("should invert the widget if it does not fit horizontally", function() {
            assert(widget.invertX.calledOnce);
            return assert.isFalse(widget.invertY.called);
        });
        it("should invert the widget if it does not fit vertically", function() {
            assert.isFalse(widget.invertX.called);
            return assert(widget.invertY.calledOnce);
        });
        it("should invert the widget if it does not fit horizontally or vertically", function() {
            assert(widget.invertX.calledOnce);
            return assert(widget.invertY.calledOnce);
        });
        it("should invert the widget if it does not fit vertically and the window is scrolled", function() {
            assert.isFalse(widget.invertX.called);
            return assert(widget.invertY.calledOnce);
        });
        return it("should invert the widget if it fits horizontally due to the window scrolled", function() {
            assert.isFalse(widget.invertX.called);
            return assert.isFalse(widget.invertY.called);
        });
    });
});

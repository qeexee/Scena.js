#
# Scena.MainCanvas class
#
class window.Scena.MainCanvas extends window.Scena.EventListener
  constructor: (@dom) ->
    @selectionChangesListeners = []

    @container = document.createElement('div')
    @container.classList.add('container')
    @dom.appendChild(@container)

    rubber_band_ele = document.createElement('div')
    @dom.appendChild(rubber_band_ele)
    @rubber_band = new Scena.RubberBand(rubber_band_ele)

    @dragging = false

    @dom.addEventListener('mousedown', @mouseDown)
    @dom.addEventListener('mouseup', @mouseUp)
    @dom.addEventListener('mousemove', @mouseMove)
    @dom.addEventListener('dblclick', @doubleClick)

    @currentIndex = null


  selectedItems: ->

  addSelectionChangesListener: (listener) ->
    @selectionChangesListeners.push(listener)

  mouseDown: (e) =>
    under = window.document.elementFromPoint(e.clientX, e.clientY)
    if under == @dom || under.tagName.match(/section/i)
      eleX = e.clientX - @dom.offsetLeft
      eleY = e.clientY - @dom.offsetTop
      @rubber_band.startRubberBand(eleX, eleY)
      @dragging = true
      @updateSelection()
    else
      under.classList.add('selected')

  mouseUp: (e) =>
    @dragging = false
    @rubber_band.stopRubberBand()

  mouseMove: (e) =>
    if @dragging
      eleX = e.clientX - @dom.offsetLeft
      eleY = e.clientY - @dom.offsetTop
      @rubber_band.updateRubberBand(eleX, eleY)
      @updateSelection()

  doubleClick: (e) =>
    under = window.document.elementFromPoint(e.clientX, e.clientY)
    if under.tagName.match(/h[1-5]/i)
      item = new Scena.TextItem(under)
      item.addEventListener('commit', @updateCurrentPage)

  updateCurrentPage: =>
    updated = @container.children[0]
    doc = Scena.Document.currentDocument()
    doc.updatePage(@currentIndex, updated)
    @setCurrentPage(@currentIndex)
    @invokeEventListeners('update')

  intersects: (x1, y1, w1, h1, x2, y2, w2, h2) ->
    return false if (x1 + w1 < x2)
    return false if (y1 + h1 < y2)
    return false if (x2 + w2 < x1)
    return false if (y2 + h2 < y1)
    return true

  setCurrentPage: (index) ->
    doc = Scena.Document.currentDocument()
    page = doc.pageAt(index)
    cloned = page.cloneNode(true)
    @container.innerHTML = ''
    @container.appendChild(cloned)
    @currentIndex = index

  updateSelection: ->
    for e in @container.getElementsByTagName('*')
      continue if e.tagName.match(/section/i)
      if @intersects(@rubber_band.x(), @rubber_band.y(),
                     @rubber_band.width(), @rubber_band.height()
                     e.offsetLeft, e.offsetTop,
                     e.offsetWidth, e.offsetHeight)
        e.classList.add('selected')
      else
        e.classList.remove('selected')
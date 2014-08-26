describe 'Test of animation.coffee', ->


  beforeEach ->

  afterEach ->

  it 'constructor and finalize', ->
    animationEle = window.document.createElement('animation')
    animationEle.innerHTML = '''
      <keyframe target='#div_id'  duration='500ms'/>
      <keyframe target='.div_cls' background-color='green' />
    '''
    anime = new Scena.KeyframeAnimation(animationEle, 'animation_style_test')
    style = window.document.getElementById('animation_style_test')
    expect(style).not.toBeNull()

    anime.finalize()
    style = window.document.getElementById('animation_style_test')
    expect(style).toBeNull()

  it 'nextKeyframe()', ->
    animationEle = window.document.createElement('animation')
    animationEle.innerHTML = '''
      <keyframe target='#div_id'  duration='500ms'/>
      <keyframe target='.div_cls' background-color='green' />
    '''
    anime = new Scena.KeyframeAnimation(animationEle)

    anime.nextKeyframe()
    div = window.document.getElementById('div_id')
    expect(window.getComputedStyle(div).transitionDuration).toBe('0.5s')

    anime.nextKeyframe()
    div = window.document.getElementsByClassName('div_cls')[0]
    expect(window.getComputedStyle(div).backgroundColor).toBe('rgb(0, 128, 0)')

    anime.finalize()

  it 'out of stack', ->
    animationEle = window.document.createElement('animation')
    animationEle.innerHTML = '''
      <keyframe target='#div_id'  duration='500ms'/>
      <keyframe target='.div_cls' background-color='green' />
    '''
    anime = new Scena.KeyframeAnimation(animationEle)
    expect(anime.nextKeyframe()).not.toBeNull()
    expect(anime.nextKeyframe()).not.toBeNull()
    expect(anime.nextKeyframe()).toBeNull()
    anime.finalize()


  it 'hasNextKeyframe', ->
    animationEle = window.document.createElement('animation')
    animationEle.innerHTML = '''
      <keyframe target='#div_id'  duration='500ms'/>
      <keyframe target='.div_cls' background-color='green' />
    '''
    anime = new Scena.KeyframeAnimation(animationEle)

    expect(anime.hasNextKeyframe()).toBeTruthy()

    anime.nextKeyframe()
    expect(anime.hasNextKeyframe()).toBeTruthy()

    anime.nextKeyframe()
    expect(anime.hasNextKeyframe()).toBeFalsy()

    anime.finalize()

  it 'methos() after finalize', ->
    animationEle = window.document.createElement('animation')
    animationEle.innerHTML = '''
      <keyframe target='#div_id'  duration='500ms'/>
      <keyframe target='.div_cls' background-color='green' />
    '''
    anime = new Scena.KeyframeAnimation(animationEle)
    anime.finalize()

    expect(anime.hasNextKeyframe()).toBeNull()

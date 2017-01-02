<template lang="pug">
  #wrap
    #main.container.clear-top
      .row
        router-link(to='/')
          img(src='/static/img/logo.png', style='width: 300px; margin-bottom: 10px; margin-top: 20px;', alt='')
      router-view
</template>

<script>
import home from './components/home'
import membership from './components/membership'

export default {
  name: 'app',
  components: {
    home,
    membership
  }
}
</script>

<style lang="stylus">
  .hero-unit
    margin-top 10px
    background url(/static/img/vancouver.jpg)
    background-size 100% 100%
    p
      background rgba(255, 255, 255, 0.8)
      padding 10px

  .navbar-inverse, .navbar-inverse .navbar-link, .navbar-inverse .brand, .navbar-inverse .nav > li > a
    color #eee

  footer
    background black
    color #ddd
    padding 10px 0px 2px 5px
    margin 0
    text-align right

  #ask, #bid
    color #999

  div
    &.item
      width 500px
      border 1px solid #aaa
      padding 10px
      margin 10px
      clear both
      img
        height 180px
        padding 10px
      p
        padding 0 10px 10px 10px
      h2
        a
          text-decoration none
          color #000
    &.row-fluid
      td
        &.first
          text-align right

  .heading
    .pull-right
      margin-top 10px

  html, body
    height 100%

  a
    color #1889A6

  #main
    overflow auto
    padding-bottom 40px

  .footer
    position relative
    margin-top -20px
    height 40px
    clear both
    padding 20px

  #mapcontainer
    overflow hidden
    width 1000px

  #merchlist
    width 350px
    float left
    overflow hidden
    ul
      list-style-type none
      padding 0px !important
      margin 0px
    li
      padding 0px
      font-weight bold
      border-bottom 1px dashed #CCCCCC
      margin-right 40px
      overflow hidden
      padding-top 10px
      padding-bottom 10px
      &:hover
        background #EEEEEE
        cursor pointer
        cursor hand

  .merchinfo
    overflow hidden
    text-decoration none

  .merchaddress
    font-size 0.7em
    color #999999

  .logoimg
    width 60px
    margin-right 10px
    float left

  #map_canvas
    width 600px
    height 600px
    overflow hidden

  label
    float left
    padding-right 10px
    padding-top 5px

  h1
    margin-top 40px

  p
    text-align justify

  .btn-primary
    background-color #1B677B !important

  .btn-success
    background #258AA5

  #partners
    h2 
      clear both

  img
    float right
    max-height 200px
    margin-left 40px
    margin-bottom 40px
    overflow hidden
</style>

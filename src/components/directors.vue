<template lang="pug">
  div
    h1 2015 Board of Directors
    .masonry.js-masonry(data-masonry-options='{ "columnWidth": 550 }')
      .item(style='overflow: auto')
        img.pull-left(src='/static/img/adam.jpg', alt='')
        h3 Adam Soltys
        p
          | Adam is the developer of CoinOS, an open source Bitcoin point of sale application. He trades food for bitcoins through Yummy Yards, an urban farming business
        p
          a(href='mailto:adam@bitcoincoop.org') adam@bitcoincoop.org
      .item(style='overflow: auto')
        h3 Andrew Wagner
        |  
        img.pull-left(src='/static/img/andrew.jpg', alt='')
        p
          | Andrew operates News BTC Canada and writes for a number of other Bitcoin publications. He is a founder and organizer of Coinfest, an annual decentralized Bitcoin conference.
        p
          a(href='mailto:andrew@bitcoincoop.org') andrew@bitcoincoop.org
      .item(style='overflow: auto')
        h3 Ben Peters
        |  
        img.pull-left(src='/static/img/ben.jpg', alt='')
        p Ben is a founder of Bitso, Mexico&apos;s leading bitcoin exchange
        p
          a(href='mailto:ben@bitcoincoop.org') ben@bitcoincoop.org
      .item(style='overflow: auto')
        h3 Frederick Heartline
        |  
        img.pull-left(src='/static/img/freddie.jpg', alt='')
        p
          | Freddie runs Decentral Bangtown, a crypto collaboration space in downtown Vancouver
        p
          a(href='mailto:freddie@bitcoincoop.org') freddie@bitcoincoop.org
      .item(style='overflow: auto')
        h3 Gerald Cotten
        |  
        img.pull-left(src='/static/img/gerry.jpg', alt='')
        p Gerry is a founder of QuadrigaCX, Canada&apos;s leading bitcoin exchange
        p
          a(href='mailto:gerry@bitcoincoop.org') gerry@bitcoincoop.org
      .item(style='overflow: auto')
        h3 Michael Yeung
        |  
        img.pull-left(src='/static/img/mike.png', alt='')
        p
          | Mike is the founder of the Simon Fraser Bitcoin Student Club and Saftonhouse Consulting Group.
        p
          a(href='mailto:mike@bitcoincoop.org') mike@bitcoincoop.org
      .item(style='overflow: auto')
        h3 Michael Patryn
        |  
        img.pull-left(src='/static/img/mikexbt.png', alt='')
        p Mike is a founder of QuadrigaCX, Canada&apos;s leading bitcoin exchange
        p
          a(href='mailto:xbt@bitcoincoop.org') xbt@bitcoincoop.org
      .item(style='overflow: auto')
        h3 Yuri Yerofeyev
        |  
        img.pull-left(src='/static/img/yuri.jpg', alt='')
        p
          | Yuri is the founder of Taurus exchange and an active trader and operator of a Bitcoin ATM at Steamrollers
        p
          a(href='mailto:yuri@bitcoincoop.org') yuri@bitcoincoop.org
</template>

<style lang="stylus">
  div.item
    width 400px
</style>

<template lang="pug">
  div
    .hero-unit
      p
        | We're an inclusive association of individuals united by a shared interest in Bitcoin. We organize presentations, workshops and other creative outings to build community and share knowledge about technology, finance, and economics. We support businesses that accept bitcoin payments and negotiate discounts and promotions for our members.
      |  
    .row
      .span4
        h3
          i.icon-question-sign
          |  About Us
        p
          | The Bitcoin Co-op was established in 2012 by regular attendees of the Bitcoin Vancouver Meetup group. 
        
        p As a registered co-operative association in the province of British Columbia, we have an open membership structure and adhere to the 
          a(href='http://bcca.coop/content/principles', target='_blank') Co-op Principles
        p
          a(href='/static/bylaws.pdf')
            i.icon.icon-file.icon-large
            |  Bylaws
          | &nbsp;
          a(href='/static/memorandum.pdf')
            i.icon.icon-file.icon-large
            |  Memorandum
      .span4
        h3
          i.icon-calendar
          |  Meetings
        p
          | We have an Annual General Meeting each year in which we elect directors and review our organizational priorities and finances.  The AGM is open to all members of the co-op.
      .span4
        h3
          i.icon-exclamation-sign
          |  Get Involved
        p
          | Find us on 
          a(href='https://www.facebook.com/bitcoincoop/') Facebook
          |  and 
          a(href='https://twitter.com/thebitcoincoop') Twitter
          |  and come to the next
          a(href='http://www.coinfest.org/')  Coinfest
          |  to introduce yourself in person! 
        p We&apos;re a friendly bunch and are always keen to meet new people who are interested in Bitcoin.
</template>

<script>
export default {
  name: 'home'
}
</script>

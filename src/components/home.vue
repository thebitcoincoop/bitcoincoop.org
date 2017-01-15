<template lang="pug">
  div
    .hero-unit
      p
        | We're an inclusive association of individuals united by a shared interest in Bitcoin. We organize presentations, workshops and other creative outings to build community and share knowledge about technology, finance, and economics. We support businesses that accept bitcoin payments and negotiate discounts and promotions for our members.
      |  
      router-link.btn.btn-large.btn-success(to='membership', style='background: #258AA5') Click Here to Join Us
    .row
      .span4
        h3
          i.icon-question-sign
          |  About Us
        p
          | The Bitcoin Co-op was established in 2012 by regular attendees of the Bitcoin Vancouver Meetup group. As a registered co-operative association in the province of British Columbia, we have an open membership structure and adhere to the 
          a(href='http://bcca.coop/content/principles', target='_blank') Co-op Principles
          | . Members can attend our meetings, vote on resolutions, participate in elections of our board of directors and have a say in how we prioritize our projects and manage our finances. Come to our next meeting or event to get to know us and learn how you can get involved!
        p
          router-link(to='directors')
            i.icon.icon-list.icon-large
            |  Directors
          | &nbsp;
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
        p
          | For a list of our other informal meetups and events that are open to the public, visit the 
          a(rel='external', href='http://www.meetup.com/bitcoinvan/') Bitcoin Vancouver
          |  meetup group.
      .span4
        h3
          i.icon-exclamation-sign
          |  Get Involved
        p
          | Find us on 
          a(href='https://plus.google.com/u/0/communities/106219864847904618781') Google Plus
          | , 
          a(href='https://www.facebook.com/bitcoincoop/') Facebook
          |  and 
          a(href='https://twitter.com/thebitcoincoop') Twitter
          |  and come to our next 
          a(href='http://www.meetup.com/bitcoinvan/') Meetup
          |  to introduce yourself in person! We&apos;re a friendly bunch and are always keen to meet new people who are interested in Bitcoin.
</template>

<script>
export default {
  name: 'home'
}
</script>

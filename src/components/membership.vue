<template lang="pug">
  div
    h1 Membership
    p
      | Membership is open to any person or organization who shares our values and wants to participate in our activities, subject to the approval of our democratically elected 
      router-link(to='directors') Board of Directors
      | . To become a member, fill out the following form and send payment to the address provided. The fee is $20, payable in Bitcoin.
    p
      | After signing up, you&apos;ll be given a member number and recorded in our 
      router-link(to='register') register
      | . We&apos;ll invite you to attend our Annual General Meetings where you&apos;ll be able to vote on resolutions as well as nominate and elect directors. You can find more information about co-operatives by visiting the 
      a(href='http://bcca.coop/') British Columbia Co-operative Association
      |  and reading the 
      a(href='http://www.bclaws.ca/civix/document/id/complete/statreg/99028_01') BC Co-operative Association Act
      | . You can also read our 
      a(href='/static/bylaws.pdf') Bylaws
      |  and 
      a(href='/static/memorandum.pdf') Memorandum of Agreement
      | .
    .well
      h2 Registration Form
      form#register(action='/users', method='post')
        input#txid(name='txid', type='hidden')
        |  
        input#date(name='date', type='hidden')
        .form-group
          label(for='name') Full Name:
          |  
          input#name.form-control(type='text', name='name', required='')
          |  
          span
            | (Published in our 
            a(tabindex='-1', href='/register') register
            | )
        .form-group
          label(for='email') Email Address:
          |  
          input#email.form-control(type='email', name='email', required='')
          |  
          span (Not published)
        .form-group
          label(for='address') Mailing Address:
          |  
          input#address.form-control(type='text', name='address', required='')
          |  
          span (Not published)
        |  
        input.btn.btn-primary(type='submit', value='Become a Member')
    #modal.modal.fade(tabindex='-1', role='dialog')
      .modal-dialog
        .modal-content
          .modal-header
            button.close(type='button', data-dismiss='modal')
              span(aria-hidden='true') &times;
            h4.modal-title Payment
          .modal-body
            #payment_request
              p.lead
                | Please send
                span#amount
                |  BTC to:
              div(style='text-align: center')
                #qr(style='width: 50%; margin: auto;')
                h4#payment_address
            #paid.alert.alert-success(style='display: none')
              h3 Success! Welcome to the co-op!
</template>

<style lang="stylus">
  label 
    width 120px

  #qr 
    cursor pointer
</style>

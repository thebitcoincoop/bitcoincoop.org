<template lang="pug">
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



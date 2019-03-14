<template lang="pug">
  div
    h1 Membership
    p We are not taking new memberships at this time
</template>

<style lang="stylus">
  label 
    width 120px

  #qr 
    cursor pointer
</style>

<script>
  import PaymentDialog from './PaymentDialog'

  export default {
    name: 'membership',
    components: {
      PaymentDialog
    }
  }
</script>

<template>
  <b-button v-show="visible" @click="goTop" class="go-top-btn btn btn-lg btn-primary" variant="primary">
    Go Top
  </b-button>
</template>

<script>
export default {
  data() {
    return {
      visible: false
    };
  },
  methods: {
    goTop() {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    },
    handleScroll() {
      this.visible = window.scrollY > 200;
    }
  },
  mounted() {
    window.addEventListener('scroll', this.handleScroll);
  },
  destroyed() {
    window.removeEventListener('scroll', this.handleScroll);
  }
};
</script>

<style>
.go-top-btn {
  position: fixed;
  bottom: 20px;
  right: 20px;
}
</style>

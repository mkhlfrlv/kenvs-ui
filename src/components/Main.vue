<template>
<div class="container" >
    <div class="my-4">
      <input
          type="text"
          v-model="searchQuery"
          class="form-control"
          placeholder="Search by POD name..."
          @input="filterPods"
      />
    </div>

    <div v-for="{CONTAINERS, NAMESPACE, POD_NAME, RESTARTS, STATUS} in filteredPods" :key="POD_NAME"
         :class="{
            'failed': STATUS === 'Failed',
            'running': STATUS === 'Running',
            'pending': STATUS === 'Pending',
            'succeeded': STATUS === 'Succeeded'
         }"
         class="card my-2">

      <div class="card-body">
        <h5 class="card-title">{{ POD_NAME }}</h5>
        <div class="card-text">Namespace: {{ NAMESPACE }}</div>
        <div class="card-text">Status: {{ STATUS }}</div>
        <div class="card-text">Restarts: {{ RESTARTS }}</div>
        <div class="card-text">Containers:</div>
        <ul>
            <li v-for="({envs, image}, index) in CONTAINERS" :key="index">
              <div>
                Image: {{ image }}
                <button v-if="envs" class="btn btn-outline-primary btn-sm btn-block m-2" type="button" data-bs-toggle="collapse"
                        :data-bs-target="`#${POD_NAME}-${index}`" aria-expanded="false"
                        :aria-controls="`#${POD_NAME}-${index}`">show envs
                </button>
              </div>
              <div v-if="envs" class="collapse" :id="`${POD_NAME}-${index}`">
                <ul v-for="(value, key, index) in (envs)" :key="index">
                  <li> <b>{{ key }}:</b> {{ value }}</li>
                </ul>
              </div>
            </li>
        </ul>
      </div>
    </div>
  <GoTopButton />
  </div>
</template>

<script>
import GoTopButton from './GoTopButton.vue';

export default {
  name: 'PodsList',
  data() {
    return {
      pods: [],
      filteredPods: [],
      searchQuery: '',
      fetchInterval: null,
    };
  },
  components: {
    GoTopButton,
  },
  mounted() {
    this.startFetchingPods();
  },
  beforeDestroy() {
    this.stopFetchingPods();
  },
  methods: {
    startFetchingPods() {
      this.fetchPods();
      this.fetchInterval = setInterval(this.fetchPods, 15000);
    },
    stopFetchingPods() {
      if (this.fetchInterval) {
        clearInterval(this.fetchInterval);
      }
    },
    async fetchPods() {
      const response = await fetch(import.meta.env.VITE_APP_API_ENDPOINT + "/api/v1/getPods");
      const data = await response.json();
      if (response.status !== 200) {
        this.pods = ""
      } else {
        this.pods = data;
        // this.filteredPods = data;
        this.filterPods();
      }
    },
    filterPods() {
      if (this.searchQuery) {
        this.filteredPods = this.pods.filter(pod =>
            pod["POD_NAME"].toLowerCase().includes(this.searchQuery.toLowerCase())
        );
      } else {
        this.filteredPods = this.pods;
      }
    },
  },
};
</script>

<style>
.container {
  width: 90%;
}

.failed {
  background-color: #fde8e8;
}
.running {
  background-color: #eaffea;
}
.pending {
  background-color: #fffee8;
}
.succeeded {
  background-color: #e8e8e8;
}

</style>
<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-row
          class="#fdf7ec lighten-5"
          style="height: 480px;"
        >
          <v-card fluid
            outlined
            color="#fdf7ec"
            tile
          >
            <div id="home-container">
                <div id="inner">
                    <h1>Hive</h1>
                    <p class="subtitle">A Blockchain based Crowdfunding and Connecting platform.</p>
                    <v-btn
                      x-large
                      class="pd-2" 
                      outlined color="#fb9300"
                      dark
                      to="/donation"
                    >
                      Donate NGO
                    </v-btn>
                    <v-btn
                      x-large
                      class="pd-2 ma-3" 
                      color="#fb9300"
                      dark
                      to="/crowdfund"
                    >
                      Fund Startup
                    </v-btn>
                </div>
                <div id="illustration">
                    <img src="illustration.svg" id="blockchain">
                </div>
            </div>
          </v-card>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>


<script>
export default {
  data: () => ({

  }),
};
</script>

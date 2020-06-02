<template>
  <v-app style="background:#fdf7ec; margin-top: -8px"> 
    <v-app-bar app
      elevate-on-scroll
      color="#fdf7ec">
      <div id="header">
        <div class="menu">
          <ul>
            <li class="logo"><router-link tag="li" to="/"><img src="logo.png"></router-link></li>
            <li><router-link tag="li" to="/">HOME</router-link></li>
          </ul>
        </div>
      </div>
      <v-spacer></v-spacer>
      <v-btn
        small
        class="ma-1" 
        outlined color="#fb9300"
      >
        Active Wallet : {{ account }}
      </v-btn>
    </v-app-bar>

    <v-content>
      <v-container>
        <router-view></router-view>
      </v-container>
    </v-content>    
  </v-app>
</template>

<script>

import web3 from '../contracts/web3';

export default {
  name: 'App',
  components: {
  },
  mounted() {
    // this code snippet takes the account (wallet) that is currently active
    web3.eth.getAccounts().then((accounts) => {
      [this.account] = accounts;
    });
  },
  data: () => ({
    account: null,
  }),
};
</script>

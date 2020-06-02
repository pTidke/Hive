<template>
	<v-container >
		<div>
			<v-row justify="center">
		    <v-dialog v-model="startProjectDialog" max-width="800">
		      <template v-slot:activator="{ on }">
		        <v-btn
		          absolute
		          dark
		          top
		          center
		          color="#fb9300"
		          v-on="on"
		        >
		          <v-icon>mdi-plus</v-icon>
		            Start a Campaign
		        </v-btn>
		      </template>
		      <v-card>
		        <v-card-title>
		          <span class="headline">Add your campaign details here</span>
		        </v-card-title>
		        <v-card-text>
		          <v-container grid-list-md>
		              <v-layout wrap>
		                <v-flex xs12>
		                  <v-text-field
		                  	outlined
		                  	clearable
		                    label="Name of your Campaign"
		                    persistent-hint
		                    v-model="newProject.title">
		                  </v-text-field>
		                </v-flex>
		                <v-flex xs12>
		                  <v-textarea
		                  	outlined
		                  	auto-grow
		                  	rows="5"
		                    label="Cause for your Campaign"
		                    persistent-hint
		                    v-model="newProject.description">
		                  </v-textarea>
		                </v-flex>
		                <v-flex xs12 sm6>
		                  <v-text-field
		                  	outlined
		                  	clearable
		                    label="Target (ETH)"
		                    type="number"
		                    step="0.0001"
		                    min="0"
		                    v-model="newProject.amountGoal">
		                  </v-text-field>
		                </v-flex>
		                <v-flex xs12 sm6>
		                  <v-text-field
		                  	outlined
		                  	clearable
		                    label="Duration (in days)"
		                    type="number"
		                    v-model="newProject.duration">
		                  </v-text-field>
		                </v-flex>
		              </v-layout>
		            </v-container>
		        </v-card-text>
		        <v-card-actions>
		          <v-spacer></v-spacer>
			        <v-btn color="#fb9300"
			          text
			          @click="startProject"
			          :loading="newProject.isLoading">
			          Save
			        </v-btn>
		        </v-card-actions>
		      </v-card>
		    </v-dialog>
		  </v-row>
		</div>	

		<div style="margin-top:50px">
			 <v-row>
		      <v-col
		        v-for="(project, index) in projectData" :key="index" 
		        cols="12"
		        sm="4">
		        <v-hover>
	              <v-card
	          			width="400"
	          			height="460"
	                color="#fdf7ec"
	                slot-scope="{ hover }"
	                :class="`elevation-${hover ? 10 : 2}`">

	                <v-card-title primary-title>
	                  {{ project.projectTitle }}
	                  <v-spacer></v-spacer>
	                  <v-dialog v-model="dialog" fullscreen hide-overlay transition="dialog-bottom-transition">
					      <template v-slot:activator="{ on }">
					        <v-chip
					        	v-on="on"
			                    :color="stateMap[project.currentState].color"
			                    class="mt-0">
			                      {{ stateMap[project.currentState].text }}
			                  </v-chip>
					      </template>
					      <v-card>
					        <v-toolbar dark color="#fb9300">
					          <v-btn icon dark @click="dialog = false">
					            <v-icon>mdi-close</v-icon>
					          </v-btn>
					          <v-toolbar-title>{{ project.projectTitle }}</v-toolbar-title>		
					          <v-spacer></v-spacer>
					          <v-toolbar-items>
					            <v-btn dark x-large depressed text>Target is : {{ project.goalAmount / 10**18 }}  ETH</v-btn>
					          </v-toolbar-items>
					        </v-toolbar>
					        <v-list three-line subheader>
					          <v-list-item>
					            <v-list-item-content>
					              <v-list-item-title>Details of project</v-list-item-title>
					              <v-list-item>
					              	<div class="my-2 subtitle-0">
					              		
					              			{{ project.projectDesc }}{{ project.projectDesc }}{{ project.projectDesc }}{{ project.projectDesc }}
					              	</div>
					              </v-list-item>
					            </v-list-item-content>
					          </v-list-item>
					          <v-list-item>
					            <v-list-item-content>
					              <v-list-item-title>Creator Address</v-list-item-title>
					              <v-list-item-subtitle>{{ project.projectStarter }}</v-list-item-subtitle>
					            </v-list-item-content>
					          </v-list-item>
					          <v-list-item>
					            <v-list-item-content>
					              <v-list-item-title>Total Amount to be raised</v-list-item-title>
					              <v-list-item-subtitle>{{ project.goalAmount / 10**18 }}  ETH</v-list-item-subtitle>
					            </v-list-item-content>
					          </v-list-item>
					          <v-list-item>
					            <v-list-item-content>
					              <v-list-item-title>Deadline</v-list-item-title>
					              <v-list-item-subtitle >{{ new Date(project.deadline * 1000) }}</v-list-item-subtitle>
					            </v-list-item-content>
					          </v-list-item>
					          <v-list-item>
					            <v-list-item-content>
					              <v-list-item-title>Additional Details</v-list-item-title>
					              <v-list-item-subtitle>Cupidatat eu qui reprehenderit cupidatat ut deserunt esse officia ullamco dolor culpa qui sunt do. Aute in enim velit est id esse labore ex aute incididunt veniam eu veniam ut nulla dolore.</v-list-item-subtitle>
					            </v-list-item-content>
					          </v-list-item>
					          <v-list-item>
					            <v-list-item-content>
					              <v-list-item-title>More Details</v-list-item-title>
					              <v-list-item-subtitle>Lorem ipsum elit amet ut ut sunt in qui elit ut consequat aliquip minim ullamco duis est consequat ex veniam magna.</v-list-item-subtitle>
					            </v-list-item-content>
					          </v-list-item>
					        </v-list>					       
					      </v-card>
					    </v-dialog>
	                  
	                </v-card-title>

	                <v-card-text>
	                  <v-row
	                    align="center"
	                    class="mx-0"
	                  >
	                    <div class="my-0 subtitle-1 black--text">{{ project.projectDesc.substring(0, 100) }}</div>
	                    <div v-if="project.projectDesc.length > 600">...<a @click="projectData[index].dialog = true">[Show full]</a></div>
	                    <v-chip
	                      outlined
	                      label
	                      v-on="on"
	                      color="teal"
	                      class="my-4">
	                        Goal : {{ project.goalAmount / 10**18 }} ETH
	                    </v-chip>
	                      <v-spacer></v-spacer>
	                    <v-tooltip top dark>
	                      <template v-slot:activator="{ on }">
	                        <v-chip
	                          outlined
	                          label
	                          v-on="on"
	                          color="black"
	                          class="my-4">
	                            Creator Address
	                        </v-chip>
	                      </template>
	                      <span>{{ project.projectStarter }}</span>
	                    </v-tooltip>
	                    <div class="my-0 black--text">
	                      Deadline : <b>{{ new Date(project.deadline * 1000) }}</b>
	                    </div>
	                    <v-chip
	                      v-if="project.currentState == 1" label class="my-4 subtitle-0 black--text"
	                      color="red"
	                      text-color="white"
	                    >
	                      <v-avatar left>
	                        <v-icon>mdi-close-circle</v-icon>
	                      </v-avatar>
	                      Goal wasn't achieved before deadline
	                    </v-chip>
	                    <v-chip
	                      v-if="project.currentState == 2" label class="my-4 subtitle-0 black--text"
	                      color="green"
	                      text-color="white"
	                    >
	                      <v-avatar left>
	                        <v-icon>mdi-checkbox-marked-circle</v-icon>
	                      </v-avatar>
	                      {{ project.goalAmount / 10**18 }} ETH Goal has been achieved
	                    </v-chip>
	                  </v-row>
	                </v-card-text>

	                <v-divider class="mx-4" v-if="project.currentState == 0 && account != project.projectStarter"></v-divider>

	                <v-row class="ma-1 mt-2"
	                    align="baseline">
	                  <v-col
	                    cols="12"
	                    md="8"
	                    v-if="project.currentState == 0 && account != project.projectStarter"
	                  >
	                    <v-text-field
	                      label="Amount (in ETH)"
	                      outlined
	                      dense
	                      type="number"
	                      step="0.0001"
	                      min="0"
	                      v-model="project.fundAmount"
	                    ></v-text-field>
	                  </v-col>

	                  <v-col
	                    cols="12"
	                    md="4"
	                    v-if="project.currentState == 0 && account != project.projectStarter"
	                  >
	                    <v-btn
	                      class="mb-1"
	                      dark
	                      color="green"
	                      @click="fundProject(index)"
	                      :loading="project.isLoading"
	                    >
	                      Fund
	                    </v-btn>
	                  </v-col>
	                </v-row>

	                <v-row class="ma-4 mr-7" align="baseline">
	                  <v-btn block dark color="#fb9300" dark
	                    v-if="project.currentState == 1"
	                    @click="getRefund(index)"
	                    :loading="project.isLoading">
	                    Get Refund</v-btn>
	                </v-row>

	                <v-card-actions v-if="project.currentState == 0">
	                  <v-btn text large color="red">{{ project.currentAmount / 10**18 }} ETH</v-btn>
	                  <v-progress-linear
	                    height = "15"
	                    class="ma-2"
	                    striped
	                    :color="stateMap[project.currentState].color"
	                    :value="(project.currentAmount / project.goalAmount) * 100"
	                  ></v-progress-linear>
	                  <v-btn color="green" ripple="false" large text>{{ project.goalAmount / 10**18 }} ETH</v-btn>
	                </v-card-actions>
	              </v-card>
	            </v-hover>
		      </v-col>
		    </v-row>			
		</div>
	</v-container>
</template>

<script>
import crowdfundInstance from '../../contracts/donationInstance';
import crowdfundProject from '../../contracts/donationCampaignInstance';
import web3 from '../../contracts/web3';

export default {
  name: 'App',
  data() {
    return {
      startProjectDialog: false,
      account: null,
      dialog: false,
        notifications: false,
        sound: true,
        widgets: false,
      stateMap: [
        { color: 'primary', text: 'Ongoing' },
        { color: 'warning', text: 'Expired' },
        { color: 'success', text: 'Completed' },
      ],
      projectData: [],
      newProject: { isLoading: false },
    };
  },
  mounted() {
    // this code snippet takes the account (wallet) that is currently active
    web3.eth.getAccounts().then((accounts) => {
      [this.account] = accounts;
      this.getProjects();
    });
  },
  
  methods: {
    getProjects() {
      crowdfundInstance.methods.returnAllProjects().call().then((projects) => {
        projects.forEach((projectAddress) => {
          const projectInst = crowdfundProject(projectAddress);
          projectInst.methods.getDetails().call().then((projectData) => {
            const projectInfo = projectData;
            projectInfo.isLoading = false;
            projectInfo.contract = projectInst;
            this.projectData.push(projectInfo);
          });
        });
      });
    },
    startProject() {
      this.newProject.isLoading = true;
      crowdfundInstance.methods.startProject(
        this.newProject.title,
        this.newProject.description,
        this.newProject.duration,
        web3.utils.toWei(this.newProject.amountGoal, 'ether'),
      ).send({
        from: this.account,
      }).then((res) => {
        const projectInfo = res.events.ProjectStarted.returnValues;
        projectInfo.isLoading = false;
        projectInfo.currentAmount = 0;
        projectInfo.currentState = 0;
        projectInfo.contract = crowdfundProject(projectInfo.contractAddress);
        this.startProjectDialog = false;
        this.newProject = { isLoading: false };
      });
    },
    fundProject(index) {
      if (!this.projectData[index].fundAmount) {
        return;
      }

      const projectContract = this.projectData[index].contract;
      this.projectData[index].isLoading = true;
      projectContract.methods.contribute().send({
        from: this.account,
        value: web3.utils.toWei(this.projectData[index].fundAmount, 'ether'),
      }).then((res) => {
        const newTotal = parseInt(res.events.FundingReceived.returnValues.currentTotal, 10);
        const projectGoal = parseInt(this.projectData[index].goalAmount, 10);
        this.projectData[index].currentAmount = newTotal;
        this.projectData[index].isLoading = false;

        // Set project state to success
        if (newTotal >= projectGoal) {
          this.projectData[index].currentState = 2;
          this.projectData[index].contract.methods.payOut();
        }
      });
    },
    getRefund(index) {
      this.projectData[index].isLoading = true;
      this.projectData[index].contract.methods.getRefund().send({
        from: this.account,
      }).then(() => {
        this.projectData[index].isLoading = false;
      });
    },
  },
};
</script>
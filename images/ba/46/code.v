module top_module(comp1,
    v1_reg_0);output comp1;
  input [4:0]v1_reg_0;

  wire carrynet_0;
  wire carrynet_1;
  wire carrynet_2;
  wire carrynet_3;
  wire [3:0] gm1_CARRY4_O;
  wire [3:1] gms_ms_CARRY4_CO;
  wire [3:0] gms_ms_CARRY4_O;

  wire [3:0] DI;
  wire [3:0] S;

  // Setting default DI values and S values for comparison
  assign DI = 4'b0000; // For the first CARRY4
  assign S = {v1_reg_0[4], 1'b0, 1'b0, 1'b0}; // For the second CARRY4

  // Implementing a 4-bit carry logic using basic gates instead of CARRY4
  assign {carrynet_3, carrynet_2, carrynet_1, carrynet_0} = 
         (DI + {1'b0, v1_reg_0[3:0]}) >> 4;

  assign gms_ms_CARRY4_CO = carrynet_3 ? 4'b1111 : 4'b0000; // Example implementation
  assign gm1_CARRY4_O = carrynet_0 ? 4'b1111 : 4'b0000; // Example implementation

  // Compare 5'b10101 (21 in decimal) with input v1_reg_0
  assign comp1 = (v1_reg_0 == 5'b10101) ? 1'b1 : 1'b0;

endmodule
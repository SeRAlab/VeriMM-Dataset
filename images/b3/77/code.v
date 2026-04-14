module top_module(
   // Outputs
   rep_store_data_c2, sctag_scdata_stdecc_c2, 
   // Inputs
   arbdp_store_data_c2
);input  [77:0]	arbdp_store_data_c2; // Left
output  [77:0]	rep_store_data_c2;  // Top
output  [77:0]	sctag_scdata_stdecc_c2;  // Right

assign sctag_scdata_stdecc_c2 = arbdp_store_data_c2;
assign rep_store_data_c2 = arbdp_store_data_c2;

endmodule
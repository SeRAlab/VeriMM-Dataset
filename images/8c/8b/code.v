module top_module(ce_expnd_i_3,
    bus2ip_addr_i_reg_2,
    start2,
    bus2ip_addr_i_reg_3);output ce_expnd_i_3;
  input [3:0] bus2ip_addr_i_reg_2; // Define as a vector if accessing bits
  input start2;
  input [3:0] bus2ip_addr_i_reg_3; // Define as a vector if accessing bits

  wire ce_expnd_i_3;
  wire start2;

  // Updated logic using a simpler assign statement to remove the LUT3 instantiation
  assign ce_expnd_i_3 = (start2) ? bus2ip_addr_i_reg_2[3] : bus2ip_addr_i_reg_2[2];

endmodule
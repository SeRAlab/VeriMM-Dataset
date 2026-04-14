module top_module(
  input aon_io_moff_corerst, 
  input aon_io_jtagpwd, 
  input test_mode, 
  input test_iso_override, 
  input aon_io_bootrom, 
  output aon_iso, 
  output jtagpwd_iso, 
  output reg [31:0] pc_rtvec
);// The isolation cells can be handled by the UPF flow or added manually
  // We will add them manually here
  // The isolation signal should be the corerst signal
  assign aon_iso = test_mode ? test_iso_override : aon_io_moff_corerst;
  assign jtagpwd_iso = test_mode ? test_iso_override : aon_io_jtagpwd;

  // Pass the pc_rtvec signal to the main domain
  // Since this is a pad-selected signal, it does not need to be synchronized in the main domain
  assign pc_rtvec = aon_io_bootrom ? 32'h0000_1000 : 32'h2000_0000;

endmodule
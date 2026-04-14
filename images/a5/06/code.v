module top_module(
  output reg VPWR_out,
  output reg VGND_out,
  output reg VPB_out,
  output reg VNB_out
);// Define supply voltages
  parameter VPWR = 1;
  parameter VGND = 0;
  parameter VPB = 1;
  parameter VNB = 0;

  // Assign supply voltages to outputs
  assign VPWR_out = VPWR;
  assign VGND_out = VGND;
  assign VPB_out = VPB;
  assign VNB_out = VNB;

endmodule
module top_module(
  input wire clk,
  output reg VPWR,
  output reg VGND,
  output reg VPB,
  output reg VNB
);// Initialize voltage supply signals
  initial begin
    VPWR = 1;
    VGND = 0;
    VPB = 1;
    VNB = 0;
  end

endmodule
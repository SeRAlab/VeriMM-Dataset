module top_module(
  input clk,
  input rst,
  output reg VPWR,
  output reg VGND,
  output reg VPB,
  output reg VNB
);always @(posedge clk, posedge rst) begin
    if (rst) begin
      VPWR <= 0;
      VGND <= 0;
      VPB <= 0;
      VNB <= 0;
    end else begin
      VPWR <= 1;
      VGND <= 0;
      VPB <= 1;
      VNB <= 0;
    end
  end
endmodule
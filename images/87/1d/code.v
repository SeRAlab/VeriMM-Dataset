module top_module(
  input clk,
  input rst,
  input enable,
  output reg VPWR,
  output reg VGND,
  output reg VPB,
  output reg VNB
);always @(posedge clk or posedge rst) begin
    if (rst) begin
      VPB <= 0;
      VNB <= 0;
    end else if (enable) begin
      VPB <= #2 ~VPB;
      VNB <= 0;
    end else begin
      VPB <= 0;
      VNB <= 0;
    end
  end

  assign VPWR = 1;
  assign VGND = 0;

endmodule
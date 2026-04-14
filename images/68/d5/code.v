module top_module(
  input clk,
  input load,
  input shift,
  input [15:0] din,
  output reg [15:0] dout
);always @(posedge clk) begin
    if (load) begin
      dout <= din;
    end
    else if (shift) begin
      dout <= {dout[14:0], 1'b0};
    end
  end
  
endmodule
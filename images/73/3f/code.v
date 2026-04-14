module top_module(
  input wire clk,enable,
  input wire [31:0] din,
  output reg [31:0] dout
);always @ (posedge clk)
  begin
    dout  <= din + 1;
    
  end

endmodule
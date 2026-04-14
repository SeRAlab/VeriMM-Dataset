module top_module(
  input CLK,
  input EN,
  input [31:0] D,
  output reg [31:0] Q
);always @(posedge CLK) begin
    if (EN) begin
      Q <= D;
    end
  end

endmodule
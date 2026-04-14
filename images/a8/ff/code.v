module top_module(
  input CLK,
  input RST,
  input [3:0] D,
  output reg [3:0] Q
);always @(posedge CLK or negedge RST) begin
    if (!RST) begin
      Q <= 4'b0;
    end else begin
      Q <= D;
    end
  end

endmodule
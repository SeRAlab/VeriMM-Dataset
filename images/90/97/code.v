module top_module( input clk, input d, output reg [2:0] q );reg [2:0] q_reg1, q_reg2;

  always @(posedge clk) begin
    q_reg1 <= d;
    q_reg2 <= q_reg1;
    q <= q_reg2;
  end

endmodule
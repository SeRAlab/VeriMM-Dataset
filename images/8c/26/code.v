module top_module(input clk, input d, output reg [2:0] q);reg [2:0] q_reg;
  always @(posedge clk) begin
    q_reg <= {q_reg[1:0], d};
  end
  assign q = q_reg;
endmodule
module top_module(d, we, clk, rst, q);input [31:0] d;
  input clk, rst, we;
  output [31:0] q;
  reg [31:0] q_reg;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      q_reg <= 32'b0;
    end else if (we) begin
      q_reg <= d;
    end
  end

  assign q = q_reg;
endmodule
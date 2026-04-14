module top_module( D, en, clk, rst, Q );input [4:0] D;
  output [4:0] Q;
  input en, clk, rst;
  wire   n19, n20, n21, n22, n23;

  // Connect D to the first flip-flop
  reg [4:0] Q_reg;
  assign Q = Q_reg;
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      Q_reg <= 5'b0;
    end else if (en) begin
      Q_reg <= D;
    end
  end
  
endmodule
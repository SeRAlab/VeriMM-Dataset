module top_module(
  input [3:0] A, B,
  input Cin, CLK, RST,
  output [3:0] C,
  output Cout
);reg [3:0] C_reg;
  wire [3:0] sum;
  wire carry;

  assign sum = A + B + Cin;
  assign Cout = carry;

  always @(posedge CLK or negedge RST) begin
    if (RST == 0) begin
      C_reg <= 4'b0;
    end else begin
      C_reg <= sum;
    end
  end

  assign C = C_reg;

endmodule
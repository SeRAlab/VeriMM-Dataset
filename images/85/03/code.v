module top_module(inOne, inTwo, select, outSelect);parameter n = 32;
  input [n-1:0] inOne;
  input [n-1:0] inTwo;
  input select;
  output [n-1:0] outSelect;

  reg [n-1:0] outSelect;

  always @(*) begin
    case(select)
      1'b0: outSelect = inOne;
      1'b1: outSelect = inTwo;
    endcase
  end
endmodule
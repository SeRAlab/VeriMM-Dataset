module top_module(
  input [7 : 0] a,
  input [2 : 0] shift,
  output [7 : 0] res,
  output carry);assign {carry, res} = (shift == 3'b000) ? {1'b0, a} :
                        (shift == 3'b001) ? {a[7 : 0], {1'b0}}:
                        (shift == 3'b010) ? {a[6 : 0], {2'b0}}:
                        (shift == 3'b011) ? {a[5 : 0], {3'b0}}:
                        (shift == 3'b100) ? {a[4 : 0], {4'b0}}:
                        (shift == 3'b101) ? {a[3 : 0], {5'b0}}:
                        (shift == 3'b110) ? {a[2 : 0], {6'b0}}:
                        {a[1 : 0], {7'b0}};
endmodule
module top_module(a, b, opControl, c, result, czn, CC);input[7:0] a, b;
  input[1:0] opControl;
  input c, CC;
  output reg[7:0] result;
  output [2:0] czn;
  parameter [1:0] ADD = 2'b00, AND = 2'b01, OR = 2'b10;
  reg tempCarry;

  always @ ( a, b, c, opControl ) begin
    case(opControl)
    ADD:begin
          if(CC) begin{tempCarry, result} = a + b + c; end
          else begin result = a + b ; end
        end
    AND: result <= a & b;
    OR: result <= a | b;
    endcase
  end
  assign czn[0] = (tempCarry);
  assign czn[1] = (result == 0);
  assign czn[2] = (result < 0);

endmodule
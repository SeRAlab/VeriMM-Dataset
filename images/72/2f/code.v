module top_module(input [3:0] entrada, output reg[3:0] saida);always @ *
  begin
   case(entrada)
    0: saida = 0;
    1: saida = 1;
    2: saida = 3;
    3: saida = 2;
    4: saida = 6;
    5: saida = 7;
    6: saida = 5;
    7: saida = 4;
    8: saida = 12;
    9: saida = 13;
    10: saida = 15;
    11: saida = 14;
    12: saida = 10;
    13: saida = 11;
    14: saida = 9;
    15: saida = 8;
    default: saida = 0;
   endcase
  end
endmodule
module top_module(
  op, func, out
);input [5:0] op, func;
output reg [3:0] out;



always @ (op or func) begin
  case (op)
    0:
      case (func)
        0, 4: out = 0; 
        2, 6: out = 1; 
        3, 7: out = 2; 
        24: out = 3; 
        25: out = 4; 
        26: out = 5; 
        27: out = 6; 
        32: out = 7; 
        33: out = 8; 
        34: out = 9; 
        35: out = 10; 
        36: out = 11; 
        37: out = 12; 
        38: out = 13; 
        42: out = 14; 
        43: out = 15; 
        default: out = 8;
      endcase
    1, 6, 7: out = 9; 
    4, 5: out = 10; 
    8: out = 7; 
    9: out = 8; 
    10: out = 14; 
    11: out = 15; 
    12: out = 11; 
    13: out = 12; 
    14: out = 13; 
    15: out = 8; 
    default: out = 8;
  endcase
end

endmodule
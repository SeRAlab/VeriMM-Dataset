module top_module(x, y, out, func, word_op, cfi, ofi, cfo, ofo);// IO ports
  input  [15:0] x;
  input  [ 4:0] y;
  input   [1:0] func;
  input         word_op;
  output [15:0] out;
  output        cfo, ofo;
  input         cfi, ofi;

  // Net declarations
  wire [15:0] sal, sar, shr, sal16, sar16, shr16;
  wire [7:0]  sal8, sar8, shr8;
  wire ofo_shl, ofo_sar, ofo_shr;
  wire cfo_sal8, cfo_sal16, cfo_sar8, cfo_sar16, cfo_shr8, cfo_shr16;
  wire cfo16, cfo8;
  wire unchanged;

  // Module instantiations
  // Replaced with a simple multiplexer implementation
  assign out = (func == 2'b00) ? sal :
               (func == 2'b01) ? sar :
               (func == 2'b10) ? shr : 16'd0;

  // Assignments
  assign { cfo_sal16, sal16 } = x << y;
  assign { sar16, cfo_sar16 } = (y > 5'd16) ? 17'h1ffff
    : (({x,1'b0} >> y) | (x[15] ? (17'h1ffff << (17 - y))
                                     : 17'h0));
  assign { shr16, cfo_shr16 } = ({x,1'b0} >> y);

  assign { cfo_sal8, sal8 } = x[7:0] << y;
  assign { sar8, cfo_sar8 } = (y > 5'd8) ? 9'h1ff
    : (({x[7:0],1'b0} >> y) | (x[7] ? (9'h1ff << (9 - y))
                                         : 9'h0));
  assign { shr8, cfo_shr8 } = ({x[7:0],1'b0} >> y);

  assign sal     = word_op ? sal16 : { 8'd0, sal8 };
  assign shr     = word_op ? shr16 : { 8'd0, shr8 };
  assign sar     = word_op ? sar16 : { {8{sar8[7]}}, sar8 };

  assign ofo = unchanged ? ofi
             : (func[1] ? ofo_shr : (func[0] ? ofo_sar : ofo_shl));
  assign cfo16 = func[1] ? cfo_shr16
               : (func[0] ? cfo_sar16 : cfo_sal16);
  assign cfo8  = func[1] ? cfo_shr8
               : (func[0] ? cfo_sar8 : cfo_sal8);
  assign cfo = unchanged ? cfi : (word_op ? cfo16 : cfo8);
  assign ofo_shl = word_op ? (out[15] != cfo) : (out[7] != cfo);
  assign ofo_sar = 1'b0;
  assign ofo_shr = word_op ? x[15] : x[7];

  assign unchanged = word_op ? (y==5'b0) : (y[3:0]==4'b0);
endmodule
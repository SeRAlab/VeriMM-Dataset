module top_module(a, b, yuu, yus, ysu, yss);input   [7:0] a, b;
output [15:0] yuu, yus, ysu, yss;




assign yuu =         a  |         b ;
assign yus =         a  | $signed(b);
assign ysu = $signed(a) |         b ;
assign yss = $signed(a) | $signed(b);

endmodule
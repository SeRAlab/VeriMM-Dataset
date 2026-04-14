module dffr_ns_r1 (din, clk, rst, q);
parameter SIZE = 1;
input   [SIZE-1:0]      din ;   
input                   clk ;   
input                   rst ;   
output  [SIZE-1:0]      q ;     
reg     [SIZE-1:0]      q ;
always @ (posedge clk)
  q[SIZE-1:0] <= rst ? {SIZE{1'b1}} : din[SIZE-1:0];
endmodule
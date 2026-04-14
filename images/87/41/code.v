module top_module(din, clk, set_l, q);// synopsys template
parameter SIZE = 1;

input   [SIZE-1:0]      din ;   // data in
input                   clk ;   // clk or scan clk
input                   set_l ; // set

output  [SIZE-1:0]      q ;     // output

reg     [SIZE-1:0]      q ;

// synopsys sync_set_reset "set_l"
always @ (posedge clk) begin
  if (!set_l) // synchronous set is active
    q[SIZE-1:0] <= din[SIZE-1:0];
  else // synchronous reset is active
    q[SIZE-1:0] <= {SIZE{1'b1}};
end

endmodule
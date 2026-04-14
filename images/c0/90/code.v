module sd_counter
  (
    output reg [9:1] q,
    output [9:1]    q_bin,
    input cke,
    input clk,
    input rst
   );
   reg [9:1] qi;
   wire [9:1] q_next;   
   assign q_next =
   qi + 9'd1;
   always @ (posedge clk or posedge rst)
     if (rst)
       qi <= 9'd0;
     else
   if (cke)
     qi <= q_next;
   always @ (posedge clk or posedge rst)
     if (rst)
       q <= 9'd0;
     else
       if (cke)
	 q <= (q_next>>1) ^ q_next;
   assign q_bin = qi;
endmodule
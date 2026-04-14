module top_module(input wire [3:0]  a,
	     input wire [3:0]  b,
	     input wire        c1,
	     input wire        c2,
	     input wire        c3,
	     
	     output wire [3:0] q,
	     output wire       f,
	     output wire       g,
	     
	     input wire        clk,
	     input wire        rst);reg [3:0] 		       ra;
   reg [3:0] 		       rb;

   wire [3:0] 		       ra_next;
   wire [3:0] 		       rb_next;

   assign ra_next = c1 ? a :
		    c2 ? (ra - rb) :
		    ra;

   assign rb_next = c1 ? b :
		    c3 ? (rb - ra) :
		    rb;
   
   assign f = (ra > rb);
   assign g = (ra == rb);
   assign q = g ? ra : 4'b0;
   
   always @(posedge clk, posedge rst)
     begin
	if (rst)
	  begin
	     ra <= 4'b0;
	     rb <= 4'b0;
	  end
	else
	  begin
	     ra <= ra_next;
	     rb <= rb_next;
	  end
     end

endmodule
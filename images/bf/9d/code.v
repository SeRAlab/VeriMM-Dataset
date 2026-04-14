module top_module(
    input clk,
    input[10:0] hcount,
    input[9:0] vcount,
    input blank,
    input[15:0] x,
    input[15:0] y,
    output reg[11:0] addr
    );wire outofbounds;
	 
	 reg[15:0] fulladdr;
	 
	 
	 parameter xoffset = 16'd35;
	 parameter yoffset = 16'd25;
	 
	 

		
		assign outofbounds = (blank) 
									||((hcount < x) && hcount < x - xoffset+2)
									||(hcount > x && hcount > x + xoffset-2)
									||(vcount < y && vcount < y - yoffset+2)
									||(vcount > y && vcount > y + yoffset-2); 

	 
	 always @(posedge clk) begin
		if (outofbounds) begin
			fulladdr <= 0;
		end else begin
			fulladdr <= (vcount + yoffset - y)*70 + (hcount + xoffset - x);
		end
		addr <= fulladdr[11:0];
	 end
	 




endmodule
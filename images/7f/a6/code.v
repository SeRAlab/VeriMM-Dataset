module top_module(q, d, si, sm, clk, c);output q; 
input  d, si, sm, clk, c;

       reg q;

        always @(posedge clk or posedge c) begin
		if (c)
		  	q <= #1 1'b0;	
                else if (sm==1'b0) 
		  	q <= #1 d;
                else if (sm==1'b1)
		  	q <= #1 si;
                else    q <= #1 1'bx;
        end


endmodule
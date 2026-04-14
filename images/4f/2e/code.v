module top_module(q, d, si, sm, clk, s);output q; 
input  d, si, sm, clk, s;

       reg q;

        always @(posedge clk or posedge s) begin
		if (s)
		  	q <= #1 1'b1;	
                else if (sm==1'b0) 
		  	q <= #1 d;
                else if (sm==1'b1)
		  	q <= #1 si;
                else    q <= #1 1'bx;
        end

endmodule
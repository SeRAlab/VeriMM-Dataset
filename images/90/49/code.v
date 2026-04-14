module top_module(q, d, clk);output	q; 
input   d, clk;


        reg q;

         always @(posedge (clk)) begin
            	q <= #1 d;
        end

endmodule
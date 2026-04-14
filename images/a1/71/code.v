module top_module(q, clk, reset);output [4:0]    q;
input           clk, reset;

reg [4:0]       q;

always @(negedge clk)
begin 
    if (reset)  
        q <= 5'b00000;
    else        
        q <= q + 1'b1;
end

endmodule
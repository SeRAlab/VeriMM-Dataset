module top_module(q,reset,data,clk);output reg q;

input reset;
input data;
input clk;

always @(posedge clk ) 

    
    if(reset) 
        begin 
        q<=1'b0;
        end
    else
        begin
        q<=data;
        end


endmodule
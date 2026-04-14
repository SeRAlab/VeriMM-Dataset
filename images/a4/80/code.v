module top_module(
    input clk,
    input async_in,
    input reset,
    output reg sync_out
    );reg meta;

always @(posedge clk) 
    if (reset)
       begin
        meta <= 1'b0;
        sync_out <= 1'b0;
       end
    else
       begin
        meta <= async_in;
        sync_out <= meta;
       end


endmodule
module d_ff_async_clear (
    input wire clk,
    input wire clear,
    input wire d,
    output reg q
);
 
    always @(posedge clk or posedge clear) begin
        if (clear)
            q <= 1'b0;
        else
            q <= d;
    end
 
endmodule
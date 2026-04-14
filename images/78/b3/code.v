module async_counter (
    input clk,
    input reset,
    input en,
    output reg [1:0] q);always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 2'b00;
    else if (en)
        q <= q + 1;
end
endmodule
module binary_counter_7bit (
    input clk,
    input reset,
    input en,
    output reg [6:0] q);
always @(posedge clk) begin
    if (reset)
        q <= 7'b0000000;
    else if (en)
        q <= q + 2;
end
endmodule
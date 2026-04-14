module up_counter (
    input clk,
    input en,
    output reg [3:0] q);always @(posedge clk) begin
    if (en)
        q <= q + 1;
end
endmodule
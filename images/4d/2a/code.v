module binary_counter (
    input clk,
    input reset,
    input en,
    output reg [9:0] q);

always @(posedge clk) begin
    if (reset)
        q <= 10'b0000000000;
    else if (en) begin
        q <= q + 1;
    end
end

endmodule
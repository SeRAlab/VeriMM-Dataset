module down_counter (
    input clk,
    input reset,
    input en,
    output reg [7:0] q);

always @(negedge clk) begin
    if (reset)
        q <= 8'b11111111;
    else if (en) begin
        q <= q - 1;
    end
end

endmodule
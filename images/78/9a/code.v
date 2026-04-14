module down_counter_11bit (
    input clk,
    input reset_n,
    input en,
    output reg [10:0] q);

always @(posedge clk) begin
    if (!reset_n)
        q <= 11'b11111111111;
    else if (en) begin
        q <= q - 1;
    end
end

endmodule
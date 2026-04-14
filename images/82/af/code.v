module down_counter (
    input clk,
    input reset_n,
    input en,
    input clear,
    output reg [19:0] q);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        q <= 20'b00000000000000000000;
    else if (clear)
        q <= 20'b00000000000000000000;
    else if (en)
        q <= q - 1;
end

endmodule
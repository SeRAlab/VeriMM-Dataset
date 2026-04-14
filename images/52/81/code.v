module up_down_counter_4bit(
    input       clk,
    input       reset,
    input       up_down,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (up_down)
        q <= q + 1;
    else
        q <= q - 1;
end

endmodule
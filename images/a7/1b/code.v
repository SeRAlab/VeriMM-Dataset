module binary_counter_3bit(
    input       clk,
    input       reset,
    input       en,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 3'b000;
    else if (en)
        q <= q + 1;
end

endmodule
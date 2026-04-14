module shift_register_4bit(
    input       clk,
    input       reset,
    input       d,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= {q[2:0], d};
end

endmodule
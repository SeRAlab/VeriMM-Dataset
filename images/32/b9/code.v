module bluetooth_strength_comparator (
    input [4:0] signal_strength_a,
    input [4:0] signal_strength_b,
    output reg [1:0] strength_output // 00: A < B, 01: A = B, 10: A > B
);

always @* begin
    if (signal_strength_a > signal_strength_b) begin
        strength_output = 2'b10; // A is stronger
    end else if (signal_strength_a < signal_strength_b) begin
        strength_output = 2'b00; // B is stronger
    end else begin
        strength_output = 2'b01; // Equal
    end
end

endmodule
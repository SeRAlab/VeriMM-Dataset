module decoder_2to4_with_enable(
    input [1:0] in,
    input enable,
    output reg [3:0] out
);

always @(*)
begin
    if (enable)
        case (in)
            2'b00: out = 4'b0001; // 0
            2'b01: out = 4'b0010; // 1
            2'b10: out = 4'b0100; // 2
            2'b11: out = 4'b1000; // 3
            default: out = 4'b0000; // Default case
        endcase
    else
        out = 4'b0000; // Output zero when not enabled
end

endmodule
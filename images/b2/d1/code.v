module top_module(
    input [31:0] value,
    input [4:0] shift_amount,
    input [1:0] shift_func,
    output reg [31:0] c_shift
);always @(*) begin
        case (shift_func)
            2'b00: c_shift = value << shift_amount; // Logical left shift
            2'b01: c_shift = value >> shift_amount; // Logical right shift
            2'b10: c_shift = $signed(value) >>> shift_amount; // Arithmetic right shift
            default: c_shift = value; // Default case (no shift)
        endcase
    end
endmodule
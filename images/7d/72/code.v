module top_module(
    input [15:0] D,
    input [3:0] shift_ctrl,
    output reg [15:0] Q
);always @(*) begin
        case (shift_ctrl)
            4'b0000: Q = D;             // No shift
            4'b0001: Q = D << 1;        // Logical left shift
            4'b0010: Q = D << 2;        // Logical left shift
            4'b0011: Q = D << 3;        // Logical left shift
            4'b0100: Q = D >> 1;        // Logical right shift
            4'b0101: Q = D >> 2;        // Logical right shift
            4'b0110: Q = D >> 3;        // Logical right shift
            default: Q = 16'b0;         // Default case
        endcase
    end
endmodule
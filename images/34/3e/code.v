module barrel_shifter (
    input [7:0] data_in,
    input [1:0] shift_control,
    output reg [7:0] data_out
);
    always @(*) begin
        case (shift_control)
            2'b00: data_out = data_in;            // No shift
            2'b01: data_out = data_in << 1;       // Left shift
            2'b10: data_out = data_in >> 1;       // Logical right shift
            2'b11: data_out = $signed(data_in) >>> 1; // Arithmetic right shift
            default: data_out = 8'b00000000;       // Default case
        endcase
    end
endmodule
module barrel_shifter (
    input [7:0] data_in,      // 8-bit input data
    input [1:0] shift_amount,  // 2-bit shift amount (0-3)
    input direction,           // 0 for left shift, 1 for right shift
    output reg [7:0] data_out  // 8-bit output data
);

always @(*) begin
    case (direction)
        1'b0: begin // Left shift
            data_out = data_in << shift_amount;
        end
        1'b1: begin // Right shift
            data_out = data_in >> shift_amount;
        end
        default: data_out = 8'b0; // Default case
    endcase
end

endmodule
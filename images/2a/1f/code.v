module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amount, // 3-bit control for shifting
    input shift_direction,     // 0 for left shift, 1 for right shift
    output reg [7:0] data_out
);
    always @(*) begin
        if (shift_direction == 0) begin // Left Shift
            data_out = data_in << shift_amount;
        end else begin // Right Shift
            data_out = data_in >> shift_amount;
        end
    end
endmodule
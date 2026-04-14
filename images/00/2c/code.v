module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amount,
    input direction, // 0 for left shift, 1 for right shift
    output reg [7:0] data_out
);
    always @(*) begin
        if (direction == 0) begin // Left Shift
            data_out = (data_in << shift_amount) | (data_in >> (8 - shift_amount));
        end else begin // Right Shift
            data_out = (data_in >> shift_amount) | (data_in << (8 - shift_amount));
        end
    end
endmodule
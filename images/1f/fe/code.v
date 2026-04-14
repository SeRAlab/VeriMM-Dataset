module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amount,
    input direction, // 0 for left, 1 for right
    output reg [7:0] data_out
);
    
    always @(*) begin
        if (direction == 0) begin // Left Shift
            data_out = data_in << shift_amount;
        end else begin // Right Shift
            if (data_in[7] == 1) // Arithmetic right shift
                data_out = (data_in >> shift_amount) | (8'b11111111 << (8 - shift_amount));
            else // Logical right shift
                data_out = data_in >> shift_amount;
        end
    end
endmodule
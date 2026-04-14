module barrel_shifter (
    input [7:0] data_in,
    input direction, // 0 for left, 1 for right
    input [2:0] shift_amount, // 0 to 7
    output reg [7:0] data_out
);
    always @(*) begin
        if (direction == 0) begin // left shift
            data_out = data_in << shift_amount;
        end else begin // right shift
            data_out = data_in >> shift_amount;
        end
    end
endmodule
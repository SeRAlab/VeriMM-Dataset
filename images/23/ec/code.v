module barrel_shifter (
    input [7:0] data_in,
    input [3:0] shift_amount,
    input direction, // 0 for left shift, 1 for right shift
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
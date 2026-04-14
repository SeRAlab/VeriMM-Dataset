module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amt,
    input direction, // 0 for left, 1 for right
    output reg [7:0] data_out
);
    always @* begin
        if (direction == 0) begin // Left shift
            data_out = data_in << shift_amt;
        end else begin // Right shift
            data_out = data_in >> shift_amt;
        end
    end
endmodule
module barrel_shifter(
    input [7:0] data_in,
    input [2:0] shift_amt,
    input direction,
    output reg [7:0] data_out
);
    always @(*) begin
        if (direction == 1'b0) begin // Left shift
            data_out = data_in << shift_amt;
        end else begin // Right shift
            data_out = data_in >> shift_amt;
        end
    end
endmodule
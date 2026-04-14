module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_amt,
    input ctrl,
    output reg [3:0] data_out
);
    always @(*) begin
        if (ctrl == 1'b0) begin // Left shift
            data_out = (data_in << shift_amt);
        end else begin // Right shift
            data_out = (data_in >> shift_amt);
        end
    end
endmodule
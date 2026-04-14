module barrel_shifter_16bit
(
    input [15:0] data_in,
    input [3:0] shift_amt,
    input shift_dir,
    output reg [15:0] data_out
);

always @(*) begin
    if (shift_dir) begin
        data_out = data_in >> shift_amt;
    end
    else begin
        data_out = data_in << shift_amt;
    end
end

endmodule
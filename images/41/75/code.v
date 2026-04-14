module barrel_shifter(
    input [31:0] data_in,
    input [4:0] shift_amt,
    input shift_dir,
    output reg [31:0] data_out
);
    always @(*) begin
        if (shift_dir)
            data_out = data_in << shift_amt; // Logical left shift
        else
            data_out = data_in >> shift_amt; // Logical right shift
    end
endmodule
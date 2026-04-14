module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amt,
    input shift_dir, // 0 for left shift, 1 for right shift
    output reg [7:0] data_out
);
    always @(*) begin
        if (shift_dir == 0) // left shift
            data_out = data_in << shift_amt;
        else // right shift
            data_out = data_in >> shift_amt;
    end
endmodule
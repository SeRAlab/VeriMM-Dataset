module barrel_shifter(
    input [31:0] data_in,
    input [4:0] shift_amt,
    input dir,
    output reg [31:0] data_out
    );

    always @(*) begin
        if (dir == 1'b0) begin
            data_out = data_in << shift_amt;
        end else begin
            data_out = data_in >> shift_amt;
        end
    end
endmodule
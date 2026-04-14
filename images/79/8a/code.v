module top_module(
    input [3:0] in,
    input [1:0] shift_amt,
    input dir,
    output reg [3:0] out
);always @(*) begin
        case (dir)
            0: out = in << shift_amt;
            1: out = in >> shift_amt;
        endcase
    end

endmodule
module top_module(
    input [7:0] in,
    input [2:0] shift_amount,
    input direction,
    output reg [7:0] out
);always @(*) begin
        if (direction == 0) begin // left shift
            out = in << shift_amount;
        end else begin // right shift
            out = in >> shift_amount;
        end
    end

endmodule
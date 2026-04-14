module top_module(
    input [7:0] in,
    input [2:0] shift_amount,
    input shift_direction,
    output [7:0] out
);reg [7:0] shifted;

    always @(*) begin
        case(shift_direction)
            1'b0: shifted = in >> shift_amount;
            1'b1: shifted = in << shift_amount;
        endcase
    end

    assign out = shifted;

endmodule
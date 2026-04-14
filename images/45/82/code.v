module top_module(
    input [3:0] in,
    input [1:0] shift_amt,
    input mode,
    output reg [3:0] out
);always @(*) begin
        case (shift_amt)
            2'b00: out = in; // no shift
            2'b01: out = mode ? {in[3], in[3:1]} : {1'b0, in[3:1]}; // shift by 1
            2'b10: out = mode ? {2'b11, in[3:2]} : {2'b00, in[3:2]}; // shift by 2
            2'b11: out = mode ? {3'b111, in[3]} : {3'b000, in[3]}; // shift by 3
            default: out = in; // default case
        endcase
    end

endmodule
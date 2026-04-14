module top_module(
    input [3:0] in,
    input [1:0] shift,
    output reg [3:0] out
);always @(*) begin
        case(shift)
            2'b00: out = in << 1; // logical left shift
            2'b01: out = in >> 1; // logical right shift
            2'b10: out = {in[2], in[3], in[3], in[3]}; // arithmetic left shift
            2'b11: out = {in[3], in[3], in[3], in[2]}; // arithmetic right shift
            default: out = 4'b0; // default case
        endcase
    end

endmodule
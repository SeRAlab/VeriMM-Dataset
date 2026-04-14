module top_module(
    output reg out,
    input in0,
    input in1,
    input in2,
    input in3,
    input sel0,
    input sel1
);always @(*) begin
        case ({sel1, sel0})
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
        endcase
    end

endmodule
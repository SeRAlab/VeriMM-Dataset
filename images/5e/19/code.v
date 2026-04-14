module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output reg out_always
);always @(*) begin
        case ({sel_b2, sel_b1})
            2'b00: out_always = a;
            2'b01: out_always = a;
            2'b10: out_always = b;
            2'b11: out_always = b;
        endcase
    end

endmodule
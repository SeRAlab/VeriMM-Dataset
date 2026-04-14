module top_module(
    input in_0,
    input in_1,
    input in_2,
    input in_3,
    input sel_0,
    input sel_1,
    output reg out
);always @(*) begin
    case ({sel_1, sel_0})
        2'b00: out = in_0;
        2'b01: out = in_1;
        2'b10: out = in_2;
        2'b11: out = in_3;
    endcase
end

endmodule
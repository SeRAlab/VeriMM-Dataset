module top_module(
    output reg y,
    input s2,
    input s1,
    input s0,
    input d4,
    input d3,
    input d2,
    input d1,
    input d0
);always @(*) begin
    case ({s2, s1, s0})
        3'b000: y = d0;
        3'b001: y = d1;
        3'b010: y = d2;
        3'b011: y = d3;
        3'b100: y = d4;
        default: y = 1'b0;
    endcase
end

endmodule
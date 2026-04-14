module MUX4_1 (
    input x0,
    input x1,
    input x2,
    input x3,
    input s0,
    input s1,
    output reg y
);

always @(*) begin
    case ({s1, s0})
        2'b00: y = x0;
        2'b01: y = x1;
        2'b10: y = x2;
        2'b11: y = x3;
    endcase
end

endmodule
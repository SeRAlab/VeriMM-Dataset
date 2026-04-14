module top_module(
    input A,
    input B,
    input C,
    input D,
    input SEL0,
    input SEL1,
    input RESET,
    output reg Y
);always @ (SEL1 or SEL0 or A or B or C or D or RESET) begin
    if (RESET) begin
        Y <= 1'b0; // default value for Y
    end else begin
        case ({SEL1, SEL0})
            2'b00: Y <= A;
            2'b01: Y <= B;
            2'b10: Y <= C;
            2'b11: Y <= D;
        endcase
    end
end

endmodule
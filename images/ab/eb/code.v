module top_module (
    input s,
    input p,
    output reg c
);
    always @(*) begin
        case ({s, p})
            2'b01: c = 1'b1;
            2'b10: c = 1'b0;
            2'b11: c = 1'b1;
            2'b00: c = 1'b0;
        endcase
    end
endmodule

module top_module (
    input j,
    input h,
    output reg v
);
    always @(*) begin
        case ({j, h})
            2'b10: v = 1'b0;
            2'b00: v = 1'b0;
            2'b11: v = 1'b0;
            2'b01: v = 1'b0;
        endcase
    end
endmodule

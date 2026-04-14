module top_module(
    input [1:0] SEL,
    input EN,
    output reg [15:0] Q
);always @ (SEL or EN) begin
    if (EN == 1'b0) begin
        Q <= 16'b0;
    end else begin
        case (SEL)
            2'b00: Q <= 16'b0000000000000001;
            2'b01: Q <= 16'b0000000000000010;
            2'b10: Q <= 16'b0000000000000100;
            2'b11: Q <= 16'b0000000000001000;
            default: Q <= 16'b0;
        endcase
    end
end

endmodule
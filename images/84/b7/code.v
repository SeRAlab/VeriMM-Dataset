module top_module(
    input [1:0] SEL,
    output reg [15:0] OUT
);always @(*) begin
        case(SEL)
            2'b00: OUT = 16'b0000000000000001;
            2'b01: OUT = 16'b0000000000000010;
            2'b10: OUT = 16'b0000000000000100;
            2'b11: OUT = 16'b0000000000001000;
        endcase
    end

endmodule
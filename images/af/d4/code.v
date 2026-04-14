module top_module(
    input [1:0] AB,
    output reg [15:0] Y
);always @(*) begin
        case (AB)
            2'b00: Y = 16'b0000000000000001;
            2'b01: Y = 16'b0000000000000010;
            2'b10: Y = 16'b0000000000000100;
            2'b11: Y = 16'b0000000000001000;
        endcase
    end

endmodule
module top_module(
    input [1:0] sel,
    output reg [15:0] out
);always @(*) begin
        case(sel)
            2'b00: out = 16'b0000000000000001;
            2'b01: out = 16'b0000000000000010;
            2'b10: out = 16'b0000000000000100;
            2'b11: out = 16'b0000000000001000;
            default: out = 16'b0000000000000000;
        endcase
    end

endmodule
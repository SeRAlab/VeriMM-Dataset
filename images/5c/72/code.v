module top_module(
    input [1:0] in,
    output reg [15:0] out
);always @* begin
        case (in)
            2'b00: out = 16'b0000000000000001;
            2'b01: out = 16'b0000000000000010;
            2'b10: out = 16'b0000000000000100;
            2'b11: out = 16'b0000000000001000;
        endcase
    end

endmodule
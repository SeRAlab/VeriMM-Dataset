module top_module(
    input [1:0] in,
    output reg [1:0] out
);always @* begin
        case(in)
            2'b00: out = 2'b00;
            2'b01: out = 2'b01;
            2'b10: out = 2'b10;
            2'b11: out = 2'b11;
            default: out = 2'b00;
        endcase
    end
    
endmodule
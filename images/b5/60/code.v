module top_module(input [7:0] a, b, c, d, sel, output reg [7:0] out);always @(*) begin
    case(sel)
        2'b00: out = a;
        2'b01: out = b;
        2'b10: out = c;
        2'b11: out = d;
    endcase
end

endmodule
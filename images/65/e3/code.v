module top_module(input [1:0] a, input [1:0] b, output reg [1:0] s);always @* begin
        case ({a, b})
            2'b00: s = 2'b00; // 0 + 0 = 0
            2'b01: s = 2'b01; // 0 + 1 = 1
            2'b10: s = 2'b01; // 1 + 0 = 1
            2'b11: s = 2'b10; // 1 + 1 = 2 = 0 (mod 3)
        endcase
    end
endmodule
module top_module(
    input [3:0] A,
    output reg [7:0] SevenSegValue
);always @(*)
    begin
        case(A)
            4'h0: SevenSegValue = 8'b11000000;
            4'h1: SevenSegValue = 8'b11111001;
            4'h2: SevenSegValue = 8'b10100100;
            4'h3: SevenSegValue = 8'b10110000;
            4'h4: SevenSegValue = 8'b10011001;
            4'h5: SevenSegValue = 8'b10010010;
            4'h6: SevenSegValue = 8'b10000010;
            4'h7: SevenSegValue = 8'b11111000;
            4'h8: SevenSegValue = 8'b10000000;
            4'h9: SevenSegValue = 8'b10010000;
            4'hA: SevenSegValue = 8'b10001000;
            4'hB: SevenSegValue = 8'b10000011;
            4'hC: SevenSegValue = 8'b10100111;
            4'hD: SevenSegValue = 8'b10000110;
            4'hE: SevenSegValue = 8'b10001110;
            4'hF: SevenSegValue = 8'b10011110;
            default: SevenSegValue = 8'b11111111;              
        endcase
    end

endmodule
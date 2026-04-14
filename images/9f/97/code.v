module top_module(digit, real_segments);input [3:0] digit;
    output [7:0] real_segments;
    reg [7:0] segments;
    
    assign real_segments = ~segments;
    
    always @(digit)
        case (digit)
            4'h0: segments = 8'b11111100;
            4'h1: segments = 8'b01100000;
            4'h2: segments = 8'b11011010;
            4'h3: segments = 8'b11110010;
            4'h4: segments = 8'b01100110;
            4'h5: segments = 8'b10110110;
            4'h6: segments = 8'b10111110;
            4'h7: segments = 8'b11100000;
            4'h8: segments = 8'b11111110;
            4'h9: segments = 8'b11110110;
            4'hA: segments = 8'b11101110;
            4'hB: segments = 8'b00111110;
            4'hC: segments = 8'b10011100;
            4'hD: segments = 8'b01111010;
            4'hE: segments = 8'b10011110;
            4'hF: segments = 8'b10001110;
        endcase
    
endmodule
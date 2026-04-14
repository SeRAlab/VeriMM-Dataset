module top_module(
    input      [3:0] digit,
    output reg [6:0] seven_segments
);always @*
        case (digit)
        'h0: seven_segments = 'b1000000;  
        'h1: seven_segments = 'b1111001;
        'h2: seven_segments = 'b0100100;  
        'h3: seven_segments = 'b0110000;  
        'h4: seven_segments = 'b0011001;  
        'h5: seven_segments = 'b0010010;  
        'h6: seven_segments = 'b0000010;  
        'h7: seven_segments = 'b1111000;  
        'h8: seven_segments = 'b0000000;  
        'h9: seven_segments = 'b0011000;  
        'ha: seven_segments = 'b0001000;  
        'hb: seven_segments = 'b0000011;
        'hc: seven_segments = 'b1000110;
        'hd: seven_segments = 'b0100001;
        'he: seven_segments = 'b0000110;
        'hf: seven_segments = 'b0001110;
        endcase

endmodule
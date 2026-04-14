module ofdm_modulator(  
    input wire clk,  
    input wire [3:0] symbol,  
    output reg [3:0] modulated_signal  
);  

always @(posedge clk) begin  
    case(symbol)  
        4'b0000: modulated_signal <= 4'b0000; // 0 degree  
        4'b0001: modulated_signal <= 4'b0001; // 90 degree  
        4'b0010: modulated_signal <= 4'b0010; // 180 degree  
        4'b0011: modulated_signal <= 4'b0011; // 270 degree  
        4'b0100: modulated_signal <= 4'b0100; // 360 degree  
        4'b0101: modulated_signal <= 4'b0101; // 450 degree  
        4'b0110: modulated_signal <= 4'b0110; // 540 degree  
        4'b0111: modulated_signal <= 4'b0111; // 630 degree  
        4'b1000: modulated_signal <= 4'b1000; // 720 degree  
        4'b1001: modulated_signal <= 4'b1001; // 810 degree  
        4'b1010: modulated_signal <= 4'b1010; // 900 degree  
        4'b1011: modulated_signal <= 4'b1011; // 990 degree  
        4'b1100: modulated_signal <= 4'b1100; // 1080 degree  
        4'b1101: modulated_signal <= 4'b1101; // 1170 degree  
        4'b1110: modulated_signal <= 4'b1110; // 1260 degree  
        4'b1111: modulated_signal <= 4'b1111; // 1350 degree  
        default: modulated_signal <= 4'b0000;  
    endcase  
end  
endmodule
module fft_4point(  
    input [15:0] x, // 4 points of 4-bit inputs  
    output [15:0] y // 4 points of 4-bit FFT outputs  
);  
    wire signed [7:0] A0, A1, A2, A3;  
    wire signed [7:0] B0, B1, B2, B3;  

    assign A0 = x[3:0];  
    assign A1 = x[7:4];  
    assign A2 = x[11:8];  
    assign A3 = x[15:12];  

    // FFT butterfly calculations  
    assign B0 = A0 + A1 + A2 + A3;  
    assign B1 = A0 + (A1 >>> 1) + (A2 >>> 1) + (A3 >>> 1);  
    assign B2 = A0 - (A1 >>> 1) + (A2 >>> 1) - (A3 >>> 1);  
    assign B3 = A0 - (A1 >>> 1) - (A2 >>> 1) + (A3 >>> 1);  

    // Output assignment  
    assign y = {B3, B2, B1, B0};  
endmodule
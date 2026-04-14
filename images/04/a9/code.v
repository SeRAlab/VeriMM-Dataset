module chebyshev_filter (  
    input [4:0] in_signal,  
    output reg [4:0] out_signal  
);  
    reg [4:0] z;  
    always @(*) begin  
        // Chebyshev filter coefficients (example values)  
        z = in_signal + (out_signal >> 1);  
        out_signal = z;  
    end  
endmodule
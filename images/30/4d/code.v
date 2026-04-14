module fft_8point (  
    input clk,  
    input reset,  
    input [127:0] data_in, // 8 complex numbers, each 16 bits (real + imag)  
    output reg [127:0] data_out // 8 complex numbers, each 16 bits  
);  
    // FFT implementation (simple placeholder for actual FFT logic)  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            data_out <= 128'b0;  
        else begin  
            // For simplicity, just pass the input to output (this should be replaced with actual FFT logic)  
            data_out <= data_in;  
        end  
    end  
endmodule
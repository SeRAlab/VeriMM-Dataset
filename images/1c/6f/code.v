module FFT_8point (  
    input clk,  
    input rst,  
    input [255:0] data_in, // 8 complex numbers, each 32 bits (16 bits real and 16 bits imag)  
    output reg [255:0] data_out // 8 complex FFT results  
);  
    // Internal storage for FFT computation  
    reg [255:0] fft_stage [0:2]; // 3 stages for FFT computation  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_out <= 0;  
            fft_stage[0] <= 0;  
            fft_stage[1] <= 0;  
            fft_stage[2] <= 0;  
        end  
        else begin  
            // FFT computation stages  
            fft_stage[0] <= data_in;  
            // Add FFT calculation logic here  
            // For simplification, we consider the output as the same as input for this example  
            fft_stage[1] <= fft_stage[0];  
            fft_stage[2] <= fft_stage[1];  
            data_out <= fft_stage[2];  
        end  
    end  
endmodule
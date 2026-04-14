module goertzel_algorithm(input clk, input reset, input signed [15:0] sample, output reg detected);  
    parameter TARGET_FREQ = 1000;  // Target frequency for detection  
    parameter SAMPLING_RATE = 8000;  // Sampling rate  
    parameter N = 256;  // Number of samples  
    reg signed [15:0] real_part;  
    reg signed [15:0] imag_part;  
    reg [7:0] count;  
    wire signed [15:0] coeff_real;  
    wire signed [15:0] coeff_imag;  
  
    assign coeff_real = 2 * $cos(2 * 3.141592653589793 * TARGET_FREQ / SAMPLING_RATE) * (1 << 14);  
    assign coeff_imag = 2 * $sin(2 * 3.141592653589793 * TARGET_FREQ / SAMPLING_RATE) * (1 << 14);  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            real_part <= 0;  
            imag_part <= 0;  
            count <= 0;  
            detected <= 0;  
        end else begin  
            // Goertzel algorithm computations  
            if (count < N) begin  
                real_part <= real_part + sample;  
                imag_part <= imag_part + coeff_real * sample;  
                detected <= (real_part * real_part + imag_part * imag_part) > (1 << 28);  
                count <= count + 1;  
            end else begin  
                count <= 0; // Reset for next detection cycle  
                real_part <= 0;  
                imag_part <= 0;  
            end  
        end  
    end  
endmodule
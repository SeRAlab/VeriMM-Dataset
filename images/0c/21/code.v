module fft_example (  
    input wire clk,  
    input wire rst,  
    input wire [15:0] real_in,  
    input wire [15:0] imag_in,  
    output reg [15:0] real_out,  
    output reg [15:0] imag_out  
);  
    // Simple placeholder FFT logic (not a real FFT) for testing  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            real_out <= 16'b0;  
            imag_out <= 16'b0;  
        end else begin  
            // Example transformation (not actual FFT)  
            real_out <= real_in + imag_in;  
            imag_out <= real_in - imag_in;  
        end  
    end  
endmodule
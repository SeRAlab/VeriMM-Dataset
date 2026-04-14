module fft_4point (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] real_in,  
    input wire [3:0] imag_in,  
    output reg [3:0] real_out,  
    output reg [3:0] imag_out  
);  

    reg [3:0] real_data [0:3];  
    reg [3:0] imag_data [0:3];  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            real_out <= 4'b0;  
            imag_out <= 4'b0;  
            for (i = 0; i < 4; i = i + 1) begin  
                real_data[i] <= 4'b0;  
                imag_data[i] <= 4'b0;  
            end  
        end else begin  
            // Simple FFT calculation (for demonstration purposes)  
            real_data[0] <= real_in;  
            imag_data[0] <= imag_in;  
            // Place more FFT computation here (for a full implementation)  
            // For this example, just output the input as output  
            real_out <= real_data[0];  
            imag_out <= imag_data[0];  
        end  
    end  
endmodule
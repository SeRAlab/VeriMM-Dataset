module fft_32_point (  
    input clk,  
    input rst,  
    input [15:0] real_in,  
    input [15:0] imag_in,  
    output reg [15:0] real_out,  
    output reg [15:0] imag_out,  
    input valid,  
    output reg done  
);  
    reg [4:0] stage;  
    reg [31:0] data_matrix [0:31];  
    reg [4:0] i;  
    initial begin  
        stage = 0;  
        done = 0;  
    end  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage <= 0;  
            done <= 0;  
        end else begin  
            if (valid) begin  
                data_matrix[stage] <= {real_in, imag_in};  
                stage <= stage + 1;  
                if (stage == 31) begin  
                    // Perform FFT algorithm here (omitted for brevity)  
                    // For demonstration purposes, output the input directly  
                    real_out <= data_matrix[0][31:16];  
                    imag_out <= data_matrix[0][15:0];  
                    done <= 1;  
                end  
            end  
        end  
    end  
endmodule
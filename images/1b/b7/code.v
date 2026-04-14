module IFFT_4point (  
    input clk,  
    input rst,  
    input [7:0] real_in_0,   
    input [7:0] imag_in_0,  
    input [7:0] real_in_1,   
    input [7:0] imag_in_1,  
    input [7:0] real_in_2,   
    input [7:0] imag_in_2,  
    input [7:0] real_in_3,   
    input [7:0] imag_in_3,  
    output reg [7:0] real_out_0,  
    output reg [7:0] imag_out_0,  
    output reg [7:0] real_out_1,  
    output reg [7:0] imag_out_1,  
    output reg [7:0] real_out_2,  
    output reg [7:0] imag_out_2,  
    output reg [7:0] real_out_3,  
    output reg [7:0] imag_out_3  
);  
    reg [15:0] real_temp [0:3];  
    reg [15:0] imag_temp [0:3];  
    integer i;

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < 4; i = i + 1) begin  
                real_out_0 <= 0;  
                imag_out_0 <= 0;  
                real_out_1 <= 0;  
                imag_out_1 <= 0;  
                real_out_2 <= 0;  
                imag_out_2 <= 0;  
                real_out_3 <= 0;  
                imag_out_3 <= 0;  
            end  
        end else begin  
            // IFFT computation (simplified version)
            real_temp[0] = real_in_0 + real_in_1 + real_in_2 + real_in_3;  
            imag_temp[0] = imag_in_0 + imag_in_1 + imag_in_2 + imag_in_3;  
            real_temp[1] = real_in_0 - real_in_1 + imag_in_2 - imag_in_3;  
            imag_temp[1] = imag_in_0 - imag_in_1 - real_in_2 + real_in_3;  
            real_temp[2] = real_in_0 - real_in_2 + real_in_1 - real_in_3;  
            imag_temp[2] = imag_in_0 - imag_in_2 + imag_in_1 - imag_in_3;  
            real_temp[3] = real_in_0 - real_in_3 + real_in_1 - real_in_2;  
            imag_temp[3] = imag_in_0 - imag_in_3 + imag_in_1 - imag_in_2; 

            // Scaling the output
            real_out_0 <= real_temp[0] >> 2;  
            imag_out_0 <= imag_temp[0] >> 2;  
            real_out_1 <= real_temp[1] >> 2;  
            imag_out_1 <= imag_temp[1] >> 2;  
            real_out_2 <= real_temp[2] >> 2;  
            imag_out_2 <= imag_temp[2] >> 2;  
            real_out_3 <= real_temp[3] >> 2;  
            imag_out_3 <= imag_temp[3] >> 2;  
        end  
    end  
endmodule
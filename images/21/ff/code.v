module fft_4point (
    input clk,
    input rst,
    input [15:0] x0, x1, x2, x3,   // Real input values
    output reg signed [15:0] re0, re1, re2, re3,  // Real parts of output
    output reg signed [15:0] im0, im1, im2, im3   // Imaginary parts of output
);
    
    reg [15:0] temp_re [0:3];
    reg [15:0] temp_im [0:3];
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            re0 <= 0; im0 <= 0;
            re1 <= 0; im1 <= 0;
            re2 <= 0; im2 <= 0;
            re3 <= 0; im3 <= 0;
        end else begin
            // FFT Calculation for 4-point FFT
            temp_re[0] = x0 + x1 + x2 + x3;  // Sum of all inputs
            temp_re[1] = x0 - x1 + x2 - x3;  // Difference pairs
            temp_re[2] = x0 + x1 - x2 - x3;  
            temp_re[3] = x0 - x1 - x2 + x3;

            // Imaginary parts (for this example, let's assume they are all 0)
            temp_im[0] = 0;
            temp_im[1] = 0;
            temp_im[2] = 0;
            temp_im[3] = 0;

            // Assign to output
            re0 <= temp_re[0]; im0 <= temp_im[0];
            re1 <= temp_re[1]; im1 <= temp_im[1];
            re2 <= temp_re[2]; im2 <= temp_im[2];
            re3 <= temp_re[3]; im3 <= temp_im[3];
        end
    end
endmodule
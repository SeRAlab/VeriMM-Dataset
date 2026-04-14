module fft_4point (
    input [7:0] re0, im0, // Sample 0
    input [7:0] re1, im1, // Sample 1
    input [7:0] re2, im2, // Sample 2
    input [7:0] re3, im3, // Sample 3
    output reg [7:0] out_re0, out_im0, // Output 0
    output reg [7:0] out_re1, out_im1, // Output 1
    output reg [7:0] out_re2, out_im2, // Output 2
    output reg [7:0] out_re3, out_im3  // Output 3
);
    always @(*) begin
        // FFT calculation (simplified for demonstration)
        out_re0 = re0 + re1 + re2 + re3;
        out_im0 = im0 + im1 + im2 + im3;
        out_re1 = re0 - re1 + re2 - re3;
        out_im1 = im0 - im1 + im2 - im3;
        out_re2 = re0 + re1 - re2 - re3;
        out_im2 = im0 + im1 - im2 - im3;
        out_re3 = re0 - re1 - re2 + re3;
        out_im3 = im0 - im1 - im2 + im3;
    end
endmodule
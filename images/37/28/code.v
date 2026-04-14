module fft_4_point (
    input clk,
    input rst,
    input [7:0] x_re0, x_im0, 
    input [7:0] x_re1, x_im1, 
    input [7:0] x_re2, x_im2, 
    input [7:0] x_re3, x_im3,
    output reg [7:0] y_re0, y_im0,
    output reg [7:0] y_re1, y_im1,
    output reg [7:0] y_re2, y_im2,
    output reg [7:0] y_re3, y_im3,
    input start
);
    reg [7:0] a_re[0:3];
    reg [7:0] a_im[0:3];
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            y_re0 <= 0; y_im0 <= 0;
            y_re1 <= 0; y_im1 <= 0;
            y_re2 <= 0; y_im2 <= 0;
            y_re3 <= 0; y_im3 <= 0;
        end else if (start) begin
            a_re[0] <= x_re0; a_im[0] <= x_im0;
            a_re[1] <= x_re1; a_im[1] <= x_im1;
            a_re[2] <= x_re2; a_im[2] <= x_im2;
            a_re[3] <= x_re3; a_im[3] <= x_im3;

            // FFT computation
            if (state == 0) begin
                y_re0 <= a_re[0] + a_re[1];
                y_im0 <= a_im[0] + a_im[1];

                y_re1 <= a_re[0] - a_re[1];
                y_im1 <= a_im[0] - a_im[1];

                y_re2 <= a_re[2] + a_re[3];
                y_im2 <= a_im[2] + a_im[3];

                y_re3 <= a_re[2] - a_re[3];
                y_im3 <= a_im[2] - a_im[3];
                state <= 1;
            end else if (state == 1) begin
                // Output the results, can implement further stages if needed
                state <= 0; // Reset state for next input
            end
        end
    end
endmodule
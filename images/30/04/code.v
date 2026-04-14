module fft_4point (
    input clk,
    input rst,
    input [7:0] x_re0, x_im0,
    input [7:0] x_re1, x_im1,
    input [7:0] x_re2, x_im2,
    input [7:0] x_re3, x_im3,
    output reg [15:0] y_re0, y_im0,
    output reg [15:0] y_re1, y_im1,
    output reg [15:0] y_re2, y_im2,
    output reg [15:0] y_re3, y_im3,
    output reg done
);

reg [7:0] temp_re [0:3];
reg [7:0] temp_im [0:3];
reg [2:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin
                // Load inputs into temporary arrays
                temp_re[0] <= x_re0; temp_im[0] <= x_im0;
                temp_re[1] <= x_re1; temp_im[1] <= x_im1;
                temp_re[2] <= x_re2; temp_im[2] <= x_im2;
                temp_re[3] <= x_re3; temp_im[3] <= x_im3;
                state <= 1;
            end
            1: begin
                // Perform FFT calculation (simplified for 4-point FFT)
                y_re0 <= temp_re[0] + temp_re[1] + temp_re[2] + temp_re[3];
                y_im0 <= temp_im[0] + temp_im[1] + temp_im[2] + temp_im[3];
                y_re1 <= temp_re[0] - temp_re[1] + temp_re[2] - temp_re[3];
                y_im1 <= temp_im[0] - temp_im[1] + temp_im[2] - temp_im[3];
                y_re2 <= temp_re[0] - temp_re[2] + temp_re[1] - temp_re[3];
                y_im2 <= temp_im[0] - temp_im[2] + temp_im[1] - temp_im[3];
                y_re3 <= temp_re[0] - temp_re[3] + temp_re[1] - temp_re[2];
                y_im3 <= temp_im[0] - temp_im[3] + temp_im[1] - temp_im[2];
                done <= 1;
                state <= 2;
            end
            2: begin
                // Wait for a new input
                if (done) begin
                    state <= 0; // Reset state for next input
                    done <= 0; // Reset done
                end
            end
        endcase
    end
end
endmodule
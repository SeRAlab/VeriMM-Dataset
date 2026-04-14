module fft_4point (
    input clk,
    input reset,
    input [15:0] x0_re,
    input [15:0] x0_im,
    input [15:0] x1_re,
    input [15:0] x1_im,
    input [15:0] x2_re,
    input [15:0] x2_im,
    input [15:0] x3_re,
    input [15:0] x3_im,
    output reg [15:0] y0_re,
    output reg [15:0] y0_im,
    output reg [15:0] y1_re,
    output reg [15:0] y1_im,
    output reg [15:0] y2_re,
    output reg [15:0] y2_im,
    output reg [15:0] y3_re,
    output reg [15:0] y3_im,
    output reg done
);
    reg [15:0] stage1_re [0:3];
    reg [15:0] stage1_im [0:3];
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y0_re <= 0; y0_im <= 0;
            y1_re <= 0; y1_im <= 0;
            y2_re <= 0; y2_im <= 0;
            y3_re <= 0; y3_im <= 0;
            done <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    // Stage 1: Compute first pair of FFT
                    stage1_re[0] <= x0_re + x1_re;
                    stage1_im[0] <= x0_im + x1_im;
                    stage1_re[1] <= x0_re - x1_re;
                    stage1_im[1] <= x0_im - x1_im;
                    stage1_re[2] <= x2_re + x3_re;
                    stage1_im[2] <= x2_im + x3_im;
                    stage1_re[3] <= x2_re - x3_re;
                    stage1_im[3] <= x2_im - x3_im;
                    state <= 1;
                end
                1: begin
                    // Stage 2: Combine results
                    y0_re <= stage1_re[0] + stage1_re[2];
                    y0_im <= stage1_im[0] + stage1_im[2];
                    y1_re <= stage1_re[1] + (stage1_re[3] * 0) - (stage1_im[3] * 1); // W3
                    y1_im <= stage1_im[1] + (stage1_re[3] * 1) + (stage1_im[3] * 0);
                    y2_re <= stage1_re[0] - stage1_re[2];
                    y2_im <= stage1_im[0] - stage1_im[2];
                    y3_re <= stage1_re[1] - (stage1_re[3] * 0) + (stage1_im[3] * 1);
                    y3_im <= stage1_im[1] - (stage1_re[3] * 1) + (stage1_im[3] * 0);
                    done <= 1;
                    state <= 2;
                end
                2: begin
                    // Wait for next reset
                    done <= done;
                end
            endcase
        end
    end
endmodule
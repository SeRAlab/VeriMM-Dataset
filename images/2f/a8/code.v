module fft_4point (
    input clk,
    input rst,
    input [7:0] in_real0, in_real1, in_real2, in_real3,
    input [7:0] in_imag0, in_imag1, in_imag2, in_imag3,
    output reg [7:0] out_real0, out_real1, out_real2, out_real3,
    output reg [7:0] out_imag0, out_imag1, out_imag2, out_imag3,
    output reg done
);
    reg [7:0] stage1_real[0:3];
    reg [7:0] stage1_imag[0:3];
    
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            out_real0 <= 0;
            out_real1 <= 0;
            out_real2 <= 0;
            out_real3 <= 0;
            out_imag0 <= 0;
            out_imag1 <= 0;
            out_imag2 <= 0;
            out_imag3 <= 0;
            done <= 0;
        end else begin
            case (state)
                0: begin
                    // Stage 1
                    stage1_real[0] <= in_real0 + in_real1;
                    stage1_imag[0] <= in_imag0 + in_imag1;
                    stage1_real[1] <= in_real0 - in_real1;
                    stage1_imag[1] <= in_imag0 - in_imag1;
                    stage1_real[2] <= in_real2 + in_real3;
                    stage1_imag[2] <= in_imag2 + in_imag3;
                    stage1_real[3] <= in_real2 - in_real3;
                    stage1_imag[3] <= in_imag2 - in_imag3;
                    state <= 1;
                end
                1: begin
                    // Stage 2
                    out_real0 <= stage1_real[0] + stage1_real[2];
                    out_imag0 <= stage1_imag[0] + stage1_imag[2];
                    out_real1 <= stage1_real[1] + (stage1_real[3] >> 1);
                    out_imag1 <= stage1_imag[1] + (stage1_imag[3] >> 1);
                    out_real2 <= stage1_real[0] - stage1_real[2];
                    out_imag2 <= stage1_imag[0] - stage1_imag[2];
                    out_real3 <= stage1_real[1] - (stage1_real[3] >> 1);
                    out_imag3 <= stage1_imag[1] - (stage1_imag[3] >> 1);
                    state <= 2;
                end
                2: begin
                    done <= 1;
                    state <= 2; // Stay in done state
                end
            endcase
        end
    end
endmodule
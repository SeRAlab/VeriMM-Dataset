module fft_4point (
    input clk,
    input reset,
    input [15:0] x0, 
    input [15:0] x1, 
    input [15:0] x2, 
    input [15:0] x3, 
    output reg [15:0] y0, 
    output reg [15:0] y1, 
    output reg [15:0] y2, 
    output reg [15:0] y3, 
    output reg done
);
    reg [15:0] stage0 [3:0]; 
    reg [15:0] stage1 [3:0]; 
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            done <= 0;
        end else begin
            case (state)
                0: begin
                    stage0[0] <= x0;
                    stage0[1] <= x1;
                    stage0[2] <= x2;
                    stage0[3] <= x3;
                    state <= 1;
                end
                1: begin
                    // FFT computation for 4-point
                    // For simplicity, let's assume a basic butterfly operation
                    stage1[0] <= stage0[0] + stage0[1]; // Y0
                    stage1[1] <= stage0[0] - stage0[1]; // Y1
                    stage1[2] <= stage0[2] + stage0[3]; // Y2
                    stage1[3] <= stage0[2] - stage0[3]; // Y3
                    state <= 2;
                end
                2: begin
                    y0 <= stage1[0];
                    y1 <= stage1[1];
                    y2 <= stage1[2];
                    y3 <= stage1[3];
                    done <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
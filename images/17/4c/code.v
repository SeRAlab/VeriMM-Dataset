module cnn_conv (
    input clk,
    input rst,
    input [15:0] feature_map, // 4x4 input feature map
    input [3:0] kernel,        // 2x2 kernel
    output reg [8:0] output_map // 3x3 output feature map
);
    reg [3:0] i, j; // Loop indices for convolution
    reg [7:0] sum;  // Accumulator for convolution result

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_map <= 0;
            sum <= 0;
            i <= 0;
            j <= 0;
        end else begin
            if (i < 3) begin
                if (j < 3) begin
                    sum <= feature_map[i*4+j] * kernel[0] + 
                            feature_map[i*4+j+1] * kernel[1] + 
                            feature_map[(i+1)*4+j] * kernel[2] + 
                            feature_map[(i+1)*4+j+1] * kernel[3];
                    output_map[i*3+j] <= sum;
                    j <= j + 1;
                end else begin
                    j <= 0;
                    i <= i + 1;
                end
            end
        end
    end
endmodule
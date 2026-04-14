module cnn_layer(  
    input clk,  
    input rst,  
    input [15:0] input_data,  // 4x4 input feature map flattened  
    output reg [15:0] output_data  // 2x2 output feature map flattened  
);  
    reg [3:0] state;  
    reg [15:0] kernel; // 3x3 kernel  
    reg [7:0] conv_result;  
    reg [1:0] row, col;  
    reg [3:0] i, j;  

    initial begin  
        kernel = 16'b0001001100000000; // Example kernel  
        state = 0;  
        output_data = 0;  
        row = 0;  
        col = 0;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 0;  
            output_data <= 0;  
            row <= 0;  
            col <= 0;  
        end else begin  
            case(state)  
                0: begin  
                    if (row < 2 && col < 2) begin  
                        conv_result = (input_data[(row*2 + 0)*4 + (col*2 + 0)] * kernel[0]) +  
                                      (input_data[(row*2 + 0)*4 + (col*2 + 1)] * kernel[1]) +  
                                      (input_data[(row*2 + 0)*4 + (col*2 + 2)] * kernel[2]) +  
                                      (input_data[(row*2 + 1)*4 + (col*2 + 0)] * kernel[3]) +  
                                      (input_data[(row*2 + 1)*4 + (col*2 + 1)] * kernel[4]) +  
                                      (input_data[(row*2 + 1)*4 + (col*2 + 2)] * kernel[5]) +  
                                      (input_data[(row*2 + 2)*4 + (col*2 + 0)] * kernel[6]) +  
                                      (input_data[(row*2 + 2)*4 + (col*2 + 1)] * kernel[7]) +  
                                      (input_data[(row*2 + 2)*4 + (col*2 + 2)] * kernel[8]);  
                        output_data[(row*2 + col)*4 +: 4] = conv_result;   
                        if (col == 1) begin  
                            col <= 0;  
                            row <= row + 1;  
                        end else begin  
                            col <= col + 1;  
                        end  
                    end else begin  
                        state <= 1;  
                    end  
                end  
                1: begin  
                    // Finish state  
                    state <= 1;  
                end  
            endcase  
        end  
    end  
endmodule
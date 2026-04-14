module cnn_inference(  
    input clk,  
    input rst,  
    input valid,  
    input [8*3-1:0] input_map, // 3x3 input feature map  
    input [8*2-1:0] filter,     // 2x2 filter  
    output reg [8*2-1:0] output_map // 2x2 output feature map  
);  
    reg [8*2-1:0] conv_result;  
    integer i, j;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            output_map <= 0;  
        end else if (valid) begin  
            conv_result = 0;  
            for (i = 0; i < 2; i = i + 1) begin  
                for (j = 0; j < 2; j = j + 1) begin  
                    conv_result[i*8 +: 8] = conv_result[i*8 +: 8] +  
                        (input_map[(i+j)*8 +: 8] * filter[j*8 +: 8]);  
                end  
            end  
            output_map <= (conv_result > 0) ? conv_result : 0; // ReLU activation  
        end  
    end  
endmodule
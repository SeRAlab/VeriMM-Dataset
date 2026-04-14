module cnn_convolution_2x2 (  
    input [15:0] feature_map, // 4x4 input feature map flattened  
    input [8:0] filter,       // 3x3 filter flattened  
    output reg [7:0] output_feature_map // 2x2 output feature map flattened  
);  
    integer i, j;  
    reg [7:0] temp_sum;  

    always @(*) begin  
        // Initialize output feature map  
        output_feature_map = 0;  

        // Perform convolution  
        for (i = 0; i < 2; i = i + 1) begin  
            for (j = 0; j < 2; j = j + 1) begin  
                temp_sum = 0;  
                temp_sum = temp_sum + (feature_map[i*4+j] * filter[0]); // top-left  
                temp_sum = temp_sum + (feature_map[i*4+j+1] * filter[1]); // top-middle  
                temp_sum = temp_sum + (feature_map[i*4+j+2] * filter[2]); // top-right  
                temp_sum = temp_sum + (feature_map[(i+1)*4+j] * filter[3]); // middle-left  
                temp_sum = temp_sum + (feature_map[(i+1)*4+j+1] * filter[4]); // middle-middle  
                temp_sum = temp_sum + (feature_map[(i+1)*4+j+2] * filter[5]); // middle-right  
                temp_sum = temp_sum + (feature_map[(i+2)*4+j] * filter[6]); // bottom-left  
                temp_sum = temp_sum + (feature_map[(i+2)*4+j+1] * filter[7]); // bottom-middle  
                temp_sum = temp_sum + (feature_map[(i+2)*4+j+2] * filter[8]); // bottom-right  
                output_feature_map[i*2+j] = temp_sum;  
            end  
        end  
    end  
endmodule
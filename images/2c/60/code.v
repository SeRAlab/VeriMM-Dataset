module turbo_decoder (  
    input clk,  
    input rst,  
    input [3:0] encoded_data,  
    output reg [3:0] decoded_data  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            decoded_data <= 4'b0000;  
        else begin  
            // Simple hard decision decoding (majority voting)  
            decoded_data[0] <= (encoded_data[0] + encoded_data[1] + encoded_data[2] + encoded_data[3] > 2) ? 1 : 0;  
            decoded_data[1] <= (encoded_data[0] + encoded_data[1] + encoded_data[2] + encoded_data[3] > 2) ? 1 : 0;  
            decoded_data[2] <= (encoded_data[0] + encoded_data[1] + encoded_data[2] + encoded_data[3] > 2) ? 1 : 0;  
            decoded_data[3] <= (encoded_data[0] + encoded_data[1] + encoded_data[2] + encoded_data[3] > 2) ? 1 : 0;  
        end  
    end  
endmodule
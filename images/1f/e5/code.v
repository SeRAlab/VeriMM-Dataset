module png_compression (  
    input clk,  
    input rst,  
    input [7:0] pixel_data,  
    input compress,  
    output reg [15:0] compressed_data,  
    output reg data_valid  
);  

    reg [7:0] current_pixel;  
    reg [3:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            compressed_data <= 16'b0;  
            data_valid <= 0;  
            current_pixel <= 8'b0;  
            count <= 0;  
        end else if (compress) begin  
            if (current_pixel == pixel_data) begin  
                count <= count + 1;  
            end else begin  
                if (count > 0) begin  
                    compressed_data <= {current_pixel, count};  
                    data_valid <= 1;  
                end  
                current_pixel <= pixel_data;  
                count <= 1;  
            end  
        end  
    end  
endmodule
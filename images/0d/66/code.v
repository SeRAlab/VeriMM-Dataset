module aes_8bit(input [7:0] data_in,  
                input [127:0] key,  
                input clk,  
                input rst,  
                output reg [7:0] data_out);  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_out <= 8'b0;  
        end else begin  
            // AddRoundKey operation (simplified for 8-bit)  
            data_out <= data_in ^ key[7:0];  
        end  
    end  
endmodule
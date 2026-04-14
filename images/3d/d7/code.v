module simple_des_encryption(  
    input wire [7:0] data_in,  
    input wire [7:0] key,  
    input wire clk,  
    input wire reset,  
    output reg [7:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 8'b0;  
        end else begin  
            data_out <= data_in ^ key;  
        end  
    end  
endmodule
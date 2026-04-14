module aes_8bit (  
    input wire [7:0] data_in,  
    input wire [7:0] key,  
    input wire clk,  
    output reg [7:0] data_out  
);  
    always @(posedge clk) begin  
        data_out <= data_in ^ key;  
    end  
endmodule
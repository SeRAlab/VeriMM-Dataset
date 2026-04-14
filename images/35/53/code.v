module simple_des_encryption (  
    input [63:0] data_in,  
    input [63:0] key,  
    input clk,  
    output reg [63:0] data_out  
);  
    integer i;  
    always @(posedge clk) begin  
        for (i = 0; i < 8; i = i + 1) begin  
            data_out[i*8 +: 8] <= data_in[i*8 +: 8] ^ key[i*8 +: 8];  
        end  
    end  
endmodule
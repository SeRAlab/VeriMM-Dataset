module aes_add_round_key (  
    input wire [7:0] block_in,  
    input wire [7:0] round_key,  
    input wire clk,  
    input wire rst,  
    output reg [7:0] block_out  
);  

always @(posedge clk or posedge rst) begin  
    if (rst)  
        block_out <= 8'b0;  
    else  
        block_out <= block_in ^ round_key;  
end  
endmodule
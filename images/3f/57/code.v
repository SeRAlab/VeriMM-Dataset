module HMAC (  
    input [7:0] key,  
    input [7:0] message,  
    input clk,  
    input rst,  
    output reg [7:0] hmac_out  
);  
    reg [7:0] hash;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hmac_out <= 8'b0;  
        end else begin  
            hash <= key ^ message; // Simplified hash function (XOR)  
            hmac_out <= hash ^ key; // HMAC computation  
        end  
    end  
endmodule
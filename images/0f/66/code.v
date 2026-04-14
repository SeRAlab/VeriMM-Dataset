module hmac #(parameter KEY_SIZE = 128, MESSAGE_SIZE = 128, HMAC_SIZE = 128) (  
    input clk,  
    input rst,  
    input valid,  
    input [KEY_SIZE-1:0] key,  
    input [MESSAGE_SIZE-1:0] message,  
    output reg [HMAC_SIZE-1:0] hmac_out,  
    output reg ready  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hmac_out <= 0;  
            ready <= 0;  
        end else if (valid) begin  
            // A simple HMAC calculation (placeholder)  
            hmac_out <= key ^ message;  
            ready <= 1;  
        end  
    end  
endmodule
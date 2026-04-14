module HMAC (  
    input clk,  
    input rst,  
    input [127:0] key,  
    input [127:0] message,  
    output reg [127:0] hmac_output  
);  

    reg [127:0] temp;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            hmac_output <= 128'b0;  
        else begin  
            temp <= key ^ message; // Simple hash operation (XOR)  
            hmac_output <= temp;  
        end  
    end  
endmodule
module HMAC (  
    input clk,  
    input reset,  
    input [127:0] key,  
    input [127:0] msg,  
    output reg [127:0] hmac  
);  
    reg [127:0] temp;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hmac <= 128'b0;  
        end else begin  
            temp <= key ^ msg; // Simple XOR operation for HMAC simulation  
            hmac <= temp;  
        end  
    end  
endmodule
module HMAC (  
    input clk,  
    input [7:0] key,  
    input [7:0] message,  
    output reg [7:0] hmac  
);  

    always @(posedge clk) begin  
        hmac <= key ^ message; // Simple XOR for HMAC calculation  
    end  
endmodule
module HMAC (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] key,  
    input wire [7:0] message,  
    output reg [7:0] mac  
);  
    reg [7:0] combined;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            mac <= 8'b0;  
            combined <= 8'b0;  
        end else begin  
            combined <= key ^ message; // Simple XOR operation as the hash function  
            mac <= combined;  
        end  
    end  
endmodule
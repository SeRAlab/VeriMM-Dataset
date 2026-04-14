module HMAC (  
    input wire clk,  
    input wire rst,  
    input wire [63:0] key,  
    input wire [63:0] message,  
    output reg [63:0] tag  
);  
    reg [63:0] temp;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            tag <= 64'b0;  
        end else begin  
            temp <= key ^ message;  
            tag <= (temp << 3) % 64'hFFFFFFFFFFFFFFFF;  
        end  
    end  
endmodule
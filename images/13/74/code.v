module hmac_example (  
    input [127:0] key,  
    input [127:0] message,  
    input clk,  
    input rst,  
    output reg [127:0] mac  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            mac <= 128'b0;  
        end else begin  
            mac <= key ^ message;  
        end  
    end  
endmodule
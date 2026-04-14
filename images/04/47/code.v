module hmac_generator (  
    input clk,  
    input rst,  
    input [127:0] key,  
    input [127:0] message,  
    output reg [127:0] hmac  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hmac <= 128'b0;  
        end else begin  
            hmac <= key ^ message;  
        end  
    end  
endmodule
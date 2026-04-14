module hmac (  
    input [127:0] key,  
    input [127:0] message,  
    input clk,  
    input reset,  
    output reg [127:0] hmac_out  
);  
    reg [127:0] inner_hash;  
    reg [127:0] outer_hash;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hmac_out <= 128'b0;  
        end else begin  
            inner_hash <= key ^ message; // Simple hash function (XOR)  
            outer_hash <= key ^ inner_hash;  
            hmac_out <= outer_hash;  
        end  
    end  
endmodule
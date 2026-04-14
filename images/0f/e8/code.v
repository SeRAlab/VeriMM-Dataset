module hmac_generator (  
    input [63:0] key,  
    input [63:0] message,  
    input clk,  
    input rst,  
    output reg [63:0] hash  
);  
    reg [63:0] lfsr;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hash <= 64'b0;  
            lfsr <= key;  
        end else begin  
            lfsr <= {lfsr[62:0], lfsr[63] ^ message[0]};  
            hash <= lfsr ^ message;  
        end  
    end  
endmodule
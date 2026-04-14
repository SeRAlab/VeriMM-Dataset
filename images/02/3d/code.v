module hmac #(parameter DATA_WIDTH = 32, KEY_WIDTH = 32) (  
    input wire clk,  
    input wire reset,  
    input wire [KEY_WIDTH-1:0] key,  
    input wire [DATA_WIDTH-1:0] message,  
    input wire start,  
    output reg [DATA_WIDTH-1:0] hmac_out,  
    output reg valid  
);  
    reg [DATA_WIDTH-1:0] hash;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hmac_out <= 0;  
            valid <= 0;  
            hash <= 0;  
        end else if (start) begin  
            // Simple hash function: XOR key and message  
            hash <= key ^ message;  
            hmac_out <= hash;  
            valid <= 1;  
        end  
    end  
endmodule
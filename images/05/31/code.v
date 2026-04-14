module sha256_simple (  
    input wire clk,  
    input wire rst,  
    input wire [31:0] data_in,  
    output reg [31:0] hash_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hash_out <= 32'b0;  
        end else begin  
            hash_out <= data_in ^ 32'hABCD1234;  
        end  
    end  
endmodule
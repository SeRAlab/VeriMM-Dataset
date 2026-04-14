module chacha20_core (  
    input [31:0] key,  
    input [31:0] nonce,  
    input [31:0] counter,  
    output reg [31:0] output_data  
);  
    always @(*) begin  
        output_data = (key ^ nonce) + (counter << 1);  
        output_data = (output_data << 3) | (output_data >> (32 - 3));  
    end  
endmodule
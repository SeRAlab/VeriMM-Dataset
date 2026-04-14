module chacha_round (  
    input wire [31:0] input_value,  
    input wire [31:0] key,  
    output reg [31:0] output_value  
);  
    always @(input_value or key) begin  
        output_value = (input_value + key) ^ ((input_value << 16) | (input_value >> 16));  
    end  
endmodule
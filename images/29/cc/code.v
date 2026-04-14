module hash_table (  
    input [4:0] key,  
    output reg [2:0] value  
);  

    always @(*) begin  
        case (key)  
            5'b00000: value = 3'b001; // Key 0 maps to value 1  
            5'b00001: value = 3'b010; // Key 1 maps to value 2  
            5'b00010: value = 3'b011; // Key 2 maps to value 3  
            5'b00011: value = 3'b100; // Key 3 maps to value 4  
            5'b00100: value = 3'b101; // Key 4 maps to value 5  
            default: value = 3'b000;    // Invalid key maps to value 0  
        endcase  
    end  
endmodule
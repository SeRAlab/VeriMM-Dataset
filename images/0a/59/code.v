module des_round(  
    input [63:0] data_in,  
    input [47:0] key,  
    output reg [63:0] data_out  
);  
    // Simple transformation for demonstration (not the actual DES logic)  
    always @(*) begin  
        // This is a placeholder for the actual DES round function  
        data_out = data_in ^ {key, key[47:32]};  
    end  
endmodule
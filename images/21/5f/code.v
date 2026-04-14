module des_single_round (  
    input wire [7:0] data,  
    input wire [7:0] key,  
    output reg [7:0] cipher_text  
);  
    always @(*) begin  
        cipher_text = data ^ key;  
    end  
endmodule
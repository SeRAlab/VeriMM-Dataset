module sha256_round(input [31:0] word,  
                     input [31:0] constant,  
                     output reg [31:0] out);  

    always @(*) begin  
        out = (word + constant);  
        out = {out[6:0], out[31:7]}; // Right rotate by 7 bits  
    end  
endmodule
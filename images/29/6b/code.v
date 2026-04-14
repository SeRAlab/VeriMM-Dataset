module huffman_encoder(input [3:0] data_in, output reg [2:0] code_out);  
    always @(*) begin  
        case(data_in)  
            4'b0000: code_out = 3'b000;  
            4'b0001: code_out = 3'b001;  
            4'b0010: code_out = 3'b010;  
            4'b0011: code_out = 3'b011;  
            default: code_out = 3'bxxx;  
        endcase  
    end  
endmodule
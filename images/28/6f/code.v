module viterbi_decoder (  
    input clk,  
    input rst,  
    input [1:0] encoded_in,  
    output reg [1:0] decoded_out  
);  

always @(posedge clk or posedge rst) begin  
    if (rst)  
        decoded_out <= 2'b00;  
    else begin  
        case (encoded_in)  
            2'b00: decoded_out <= 2'b00;  
            2'b01: decoded_out <= 2'b01;  
            2'b10: decoded_out <= 2'b10;  
            2'b11: decoded_out <= 2'b11;  
            default: decoded_out <= 2'b00;  
        endcase  
    end  
end  
endmodule
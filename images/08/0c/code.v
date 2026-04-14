module convolutional_encoder(  
    input clk,  
    input rst,  
    input bit_in,  
    output reg [1:0] encoded_out  
);  
    reg [2:0] shift_reg;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 3'b000;  
            encoded_out <= 2'b00;  
        end else begin  
            shift_reg <= {shift_reg[1:0], bit_in};  
            encoded_out[0] <= shift_reg[2] ^ shift_reg[1] ^ bit_in;  
            encoded_out[1] <= shift_reg[2] ^ bit_in;  
        end  
    end  
endmodule
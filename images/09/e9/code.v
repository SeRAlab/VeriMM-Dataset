module convolutional_encoder(  
    input clk,  
    input rst,  
    input [6:0] data_in,  
    output reg [13:0] data_out  
);  
    reg [6:0] shift_reg;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 7'b0;  
            data_out <= 14'b0;  
        end else begin  
            shift_reg <= {data_in, shift_reg[6:1]};  
            data_out <= {shift_reg[6] ^ shift_reg[5] ^ shift_reg[3], shift_reg[6] ^ shift_reg[4] ^ shift_reg[3] ^ shift_reg[2], shift_reg[6] ^ shift_reg[5] ^ shift_reg[1], shift_reg[6] ^ shift_reg[4] ^ shift_reg[1]};  
        end  
    end  
endmodule
module convolutional_encoder(  
    input clk,  
    input reset,  
    input data_in,  
    output reg [1:0] data_out  
);  
    reg [2:0] shift_reg; // 3 bits for the shift register (2 for storage + 1 for current input)  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 3'b000;  
            data_out <= 2'b00;  
        end else begin  
            shift_reg <= {data_in, shift_reg[2:1]};  
            data_out <= {shift_reg[2] ^ shift_reg[1] ^ shift_reg[0], shift_reg[2] ^ shift_reg[0]};  
        end  
    end  
endmodule
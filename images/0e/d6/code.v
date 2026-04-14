module turbo_encoder (  
    input wire [3:0] data_in,  
    input wire clk,  
    input wire reset,  
    output reg [7:0] encoded_out  
);  
    reg [3:0] shift_reg;  
    reg [2:0] cnt;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 4'b0000;  
            encoded_out <= 8'b00000000;  
            cnt <= 3'b000;  
        end else begin  
            shift_reg <= {data_in, shift_reg[3:1]};  
            encoded_out <= {shift_reg[3] ^ shift_reg[2], shift_reg[3] ^ shift_reg[1], shift_reg[3] ^ shift_reg[0], shift_reg[2] ^ shift_reg[1], shift_reg[2] ^ shift_reg[0], shift_reg[1] ^ shift_reg[0], data_in};  
            cnt <= cnt + 1;  
        end  
    end  
endmodule
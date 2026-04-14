module conv_encoder (  
    input clk,  
    input rst,  
    input [1:0] data_in,  
    output reg [3:0] encoded_out  
);  
    reg [2:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 3'b000;  
            encoded_out <= 4'b0000;  
        end else begin  
            shift_reg <= {data_in, shift_reg[2:1]};  
            encoded_out[3] <= shift_reg[2] ^ shift_reg[1] ^ shift_reg[0];  // g1  
            encoded_out[2] <= shift_reg[2] ^ shift_reg[0];                  // g2  
            encoded_out[1:0] <= data_in;  
        end  
    end  
endmodule
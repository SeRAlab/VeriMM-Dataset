module turbo_encoder(  
    input [3:0] data_in,  
    input clk,  
    input rst,  
    output reg [1:0] data_out  
);  

reg [3:0] shift_reg;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        shift_reg <= 4'b0;  
        data_out <= 2'b0;  
    end else begin  
        shift_reg <= {data_in, shift_reg[3:1]};  
        data_out <= {shift_reg[3] ^ shift_reg[1], shift_reg[3] ^ shift_reg[2]};  
    end  
end  
endmodule
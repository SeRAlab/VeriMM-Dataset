module crc_generator(  
    input [3:0] data_in,  
    input clk,  
    input rst,  
    output reg [2:0] crc_out  
);  
    reg [3:0] shift_reg;  
    integer i;  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc_out <= 3'b000;  
            shift_reg <= 4'b0000;  
        end else begin  
            shift_reg <= data_in;  
            crc_out <= 3'b000;  
            for (i = 0; i < 4; i = i + 1) begin  
                crc_out[i % 3] <= crc_out[i % 3] ^ shift_reg[i];  
                if (shift_reg[i]) begin  
                    shift_reg <= shift_reg ^ 4'b1011;  
                end  
            end  
        end  
    end  
endmodule
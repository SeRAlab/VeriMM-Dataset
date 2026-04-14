module crc_generator(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    output reg [3:0] crc_out  
);  
    reg [7:0] shift_reg;  
    reg [3:0] crc;  
    integer i;  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc <= 4'b0000;  
            shift_reg <= 8'b00000000;  
        end else begin  
            shift_reg <= data_in;  
            crc <= 4'b0000;  
            for (i = 0; i < 8; i = i + 1) begin  
                crc[3] = crc[2] ^ shift_reg[7];  
                crc[2] = crc[1];  
                crc[1] = crc[0];  
                crc[0] = shift_reg[7];  
                shift_reg = {shift_reg[6:0], 1'b0};  
            end  
            crc_out <= crc;  
        end  
    end  
endmodule
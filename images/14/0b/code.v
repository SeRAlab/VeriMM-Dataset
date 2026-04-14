module crc_calculator(  
    input [3:0] data,  
    input [3:0] polynomial,  
    input clk,  
    input rst,  
    output reg [3:0] crc  
);  
    reg [3:0] shift_reg;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc <= 4'b0000;  
            shift_reg <= data;  
        end else begin  
            crc <= shift_reg;  
            for (i = 0; i < 4; i = i + 1) begin  
                if (shift_reg[3] == 1'b1)  
                    shift_reg <= (shift_reg << 1) ^ polynomial;  
                else  
                    shift_reg <= shift_reg << 1;  
            end  
        end  
    end  
endmodule
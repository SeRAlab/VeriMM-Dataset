module crc_generator (  
    input [3:0] data_in,  
    input clk,  
    input rst,  
    output reg [7:0] crc_out  
);  
    reg [4:0] shift_reg;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 5'b00000;  
            crc_out <= 8'b00000000;  
        end else begin  
            shift_reg <= {shift_reg[3:0], data_in};  
            if (shift_reg[4]) begin  
                shift_reg <= shift_reg ^ 5'b11001; // Polynomial x^4 + x + 1  
            end  
            crc_out <= {shift_reg[3:0], shift_reg[4]} ; // Output data + CRC  
        end  
    end  
endmodule
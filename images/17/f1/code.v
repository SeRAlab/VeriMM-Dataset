module crc_generator (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input [3:0] polynomial,  
    output reg [3:0] crc_out  
);  

    reg [7:0] shift_reg;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 8'b0;  
            crc_out <= 4'b0;  
        end else begin  
            shift_reg <= data_in;  
            crc_out <= 4'b0;  
            for (i = 0; i < 8; i = i + 1) begin  
                if (shift_reg[7] ^ crc_out[3]) begin  
                    crc_out <= (crc_out << 1) ^ polynomial;  
                end else begin  
                    crc_out <= crc_out << 1;  
                end  
                shift_reg <= shift_reg << 1;  
            end  
        end  
    end  
endmodule
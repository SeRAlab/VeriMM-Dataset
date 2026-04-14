module crc4(clk, reset, data_in, crc_out);  
    input clk;  
    input reset;  
    input [11:0] data_in;  
    output reg [3:0] crc_out;  

    reg [11:0] data_reg;  
    reg [3:0] crc_reg;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc_out <= 4'b0000;  
            data_reg <= 12'b0;  
            crc_reg <= 4'b0000;  
        end else begin  
            data_reg <= data_in;  
            crc_reg <= 4'b0000; // Initialize CRC for new input  
            for (i = 0; i < 12; i = i + 1) begin  
                crc_reg = {crc_reg[2:0], data_reg[11-i]} ^ (crc_reg[3] ? 4'b1001 : 4'b0000);  
            end  
            crc_out <= crc_reg;  
        end  
    end  
endmodule
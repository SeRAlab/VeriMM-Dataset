module crc_generator (  
    input wire clk,  
    input wire rst,  
    input wire enable,  
    input wire [15:0] data_in,  
    input wire [15:0] polynomial,  
    output reg [15:0] crc_out,  
    output reg valid  
);  
    reg [15:0] crc_reg;  
    reg [3:0] bit_cnt;  
    reg computing;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc_reg <= 16'b0;  
            bit_cnt <= 4'b0;  
            valid <= 1'b0;  
            computing <= 1'b0;  
        end else if (enable && !computing) begin  
            crc_reg <= data_in;  
            bit_cnt <= 4'd15;  
            valid <= 1'b0;  
            computing <= 1'b1;  
        end else if (computing) begin  
            if (bit_cnt > 0) begin  
                if (crc_reg[15] ^ data_in[bit_cnt])  
                    crc_reg <= (crc_reg << 1) ^ polynomial;  
                else  
                    crc_reg <= crc_reg << 1;  
                bit_cnt <= bit_cnt - 1;  
            end else begin  
                crc_out <= crc_reg;  
                valid <= 1'b1;  
                computing <= 1'b0;  
            end  
        end  
    end  
endmodule
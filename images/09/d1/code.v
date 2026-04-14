module spi_master (  
    input wire clk,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg spi_clk,  
    output reg cs,  
    output reg mosi  
);  
    reg [2:0] bit_cnt;  
    reg [7:0] shift_reg;  
    reg sending;  

    always @(posedge clk) begin  
        if (start) begin  
            sending <= 1;  
            shift_reg <= data_in;  
            bit_cnt <= 0;  
            cs <= 0; // Activate chip select  
        end  
        else if (sending) begin  
            if (bit_cnt < 8) begin  
                spi_clk <= ~spi_clk;  
                if (spi_clk) begin  
                    mosi <= shift_reg[7 - bit_cnt];  
                    bit_cnt <= bit_cnt + 1;  
                end  
            end else begin  
                sending <= 0;  
                cs <= 1; // Deactivate chip select  
                spi_clk <= 0;  
            end  
        end  
    end  
endmodule
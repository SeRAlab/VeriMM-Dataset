module spi_controller(  
    input wire clk,        // System clock  
    input wire cs,         // Chip select  
    input wire mosi,       // Master Out Slave In  
    output reg miso        // Master In Slave Out  
);  
    reg [7:0] shift_reg;   // Shift register for data  
    reg [2:0] bit_count;   // Bit counter  

    always @(posedge clk or negedge cs) begin  
        if (!cs) begin  
            // Reset on CS low  
            shift_reg <= 8'b0;  
            bit_count <= 3'b0;  
            miso <= 1'b0;  
        end else begin  
            // Shift data into the register on each clock pulse  
            shift_reg <= {shift_reg[6:0], mosi};  
            bit_count <= bit_count + 1;  
            if (bit_count == 3'b111) begin  
                // When 8 bits have been received, output the last bit on MISO  
                miso <= shift_reg[7];  
            end  
        end  
    end  
endmodule
module spi_controller(  
    input wire clk,  
    input wire cs,  
    input wire mosi,  
    output reg miso,  
    output reg active,  
    output reg [7:0] data_out  
);  

    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  

    always @(posedge clk or negedge cs) begin  
        if (!cs) begin  
            // Chip select is active, reset state  
            bit_count <= 0;  
            active <= 1;  
            shift_reg <= 0;  
            data_out <= 0;  
        end else if (active) begin  
            // Shift data in from MOSI and output to MISO  
            shift_reg <= {shift_reg[6:0], mosi};  
            bit_count <= bit_count + 1;  

            if (bit_count == 7) begin  
                // After 8 bits, finish transfer  
                data_out <= shift_reg;  
                miso <= shift_reg[7];  
                active <= 0;  
                bit_count <= 0;  
            end else begin  
                miso <= shift_reg[7];  
            end  
        end  
    end  
endmodule
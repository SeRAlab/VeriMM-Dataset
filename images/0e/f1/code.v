module spi_master(  
    input wire clk,           // System clock  
    input wire start,         // Start signal to initiate SPI communication  
    input wire mosi_data,     // Data to send to the slave  
    output reg miso_data,      // Data received from the slave  
    output reg sclk,           // SPI clock  
    output reg cs,             // Chip select for the slave  
    output reg [7:0] data_out, // Data to be sent  
    input wire [7:0] data_in   // Data received from the slave  
);  
    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  
    reg sending;  

    always @(posedge clk) begin  
        if (start) begin  
            cs <= 0;                // Enable chip select  
            bit_count <= 0;         // Reset bit count  
            shift_reg <= mosi_data; // Load data to send  
            sending <= 1;           // Start sending data  
        end  
        else if (sending) begin  
            sclk <= ~sclk;          // Toggle clock  
            if (sclk) begin          // On the rising edge of SCLK  
                miso_data <= shift_reg[7]; // Send most significant bit  
                data_out <= {data_out[6:0], 1'b0}; // Shift out data  
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift the data register  
                bit_count <= bit_count + 1;  
            end  
            if (bit_count == 7) begin  // Last bit sent  
                cs <= 1;                // Disable chip select  
                sending <= 0;           // Stop sending  
                miso_data <= data_in;   // Read the received data  
            end  
        end  
        else begin  
            sclk <= 0;                // Ensure clock is low when not sending  
        end  
    end  
endmodule
module spi_master(  
    input wire clk,           // System clock  
    input wire reset,         // Reset signal  
    input wire start,         // Start transmission signal  
    input wire [7:0] data_in, // Data to be sent  
    output reg mosi,          // Master Out Slave In  
    output reg sck,           // Serial Clock  
    output reg cs,            // Chip Select  
    input wire miso,          // Master In Slave Out  
    output reg [7:0] data_out // Received data  
);  

    reg [3:0] bit_counter;    // Bit counter  
    reg [7:0] shift_reg;      // Shift register  
    reg sending;              // Sending flag  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            cs <= 1;           // Chip select high (inactive)  
            sck <= 0;          // Clock low  
            mosi <= 0;         // Data out low  
            data_out <= 0;     // Clear received data  
            bit_counter <= 0;   // Clear bit counter  
            sending <= 0;       // Not sending  
        end else if (start && !sending) begin  
            cs <= 0;           // Activate chip select  
            shift_reg <= data_in; // Load data into shift register  
            sending <= 1;      // Set sending flag  
            bit_counter <= 0;   // Reset bit counter  
        end else if (sending) begin  
            sck <= ~sck;       // Toggle clock  
            if (sck) begin      // On clock rising edge  
                mosi <= shift_reg[7]; // Send the MSB  
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left  
                bit_counter <= bit_counter + 1; // Increment bit counter  
            end  
            if (bit_counter == 8) begin  
                data_out <= {data_out[6:0], miso}; // Read data from MISO  
                cs <= 1;          // Deactivate chip select  
                sending <= 0;     // Clear sending flag  
            end else if (sck && bit_counter < 8) begin  
                data_out <= {data_out[6:0], miso}; // Read data from MISO  
            end  
        end  
    end  
endmodule
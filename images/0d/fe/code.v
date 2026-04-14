module uart_transmitter (  
    input clk,                // System clock  
    input rst,                // Reset  
    input enable,             // Enable transmission  
    input [7:0] data_in,     // Data to transmit  
    output reg tx,            // Transmitted serial output  
    output reg busy           // Transmitter busy flag  
);  
    parameter BAUD_RATE = 9600;  
    parameter CLOCK_FREQ = 50000000;  
    parameter BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;  

    reg [3:0] bit_index;  
    reg [15:0] counter;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            tx <= 1; // Idle state  
            busy <= 0;  
            bit_index <= 0;  
            counter <= 0;  
        end else if (enable && !busy) begin  
            busy <= 1;  
            tx <= 0; // Start bit  
            counter <= 0;  
            bit_index <= 0;  
        end else if (busy) begin  
            if (counter < BIT_PERIOD - 1) begin  
                counter <= counter + 1;  
            end else begin  
                counter <= 0;  
                if (bit_index < 8) begin  
                    tx <= data_in[bit_index]; // Send data bits  
                    bit_index <= bit_index + 1;  
                end else if (bit_index == 8) begin  
                    tx <= 1; // Stop bit  
                    bit_index <= bit_index + 1;  
                end else begin  
                    busy <= 0; // Transmission complete  
                end  
            end  
        end  
    end  
endmodule
module uart_controller(  
    input clk,  
    input tx_en,  
    input [7:0] data_in,  
    output reg tx_serial  
);  
    reg [3:0] bit_count;  
    reg [9:0] shift_reg; // 8 data bits + 1 start bit + 1 stop bit  
    reg transmitting;  
    parameter BAUD_RATE_DIV = 16; // Example for 9600 baud with 16 MHz clock  
  
    always @(posedge clk) begin  
        if (tx_en && !transmitting) begin  
            // Load the shift register with start bit, data bits, and stop bit  
            shift_reg <= {1'b1, data_in, 1'b0}; // Start with stop bit (1), data, start bit (0)  
            bit_count <= 0;  
            transmitting <= 1;  
        end else if (transmitting) begin  
            if (bit_count < 10) begin  
                tx_serial <= shift_reg[0]; // Transmit the LSB first  
                shift_reg <= shift_reg >> 1; // Shift right to prepare for next bit  
                bit_count <= bit_count + 1;  
            end else begin  
                transmitting <= 0; // Finished transmitting  
            end  
        end  
    end  
endmodule
module uart_transmitter (
    input wire clk,            // System clock
    input wire rst_n,         // Active low reset
    input wire [7:0] data_in, // 8-bit data to be transmitted
    input wire start,         // Signal to start transmission
    input wire stop,          // Signal to stop transmission
    input wire baud_tick,     // Tick signal for baud rate
    output reg tx             // Serial output
);

    reg [3:0] bit_counter;     // Counter for the number of bits transmitted
    reg [10:0] shift_reg;      // Shift register to hold the complete frame (start + data + stop)
    reg transmitting;          // Status of transmission

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1;           // Idle state of UART
            transmitting <= 0;
            bit_counter <= 0;
        end else if (start && !transmitting) begin
            // Load the shift register with start bit, data bits, and stop bit
            shift_reg <= {1'b1, data_in, 1'b0}; // Start, Data, Stop
            transmitting <= 1;
            bit_counter <= 0;
        end else if (transmitting) begin
            if (baud_tick) begin
                tx <= shift_reg[0]; // Output the least significant bit
                shift_reg <= shift_reg >> 1; // Shift right
                bit_counter <= bit_counter + 1;
                if (bit_counter == 10) begin
                    transmitting <= 0; // Transmission complete
                end
            end
        end
    end
endmodule
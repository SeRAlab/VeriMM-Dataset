module uart_transmitter (
    input wire clk,             // Clock input
    input wire reset,           // Asynchronous reset
    input wire [7:0] data_in,   // Data to transmit
    input wire start_tx,        // Start transmission signal
    output reg tx,              // UART transmit output
    output reg tx_done          // Transmission done signal
);

    reg [3:0] bit_index;        // Bit index for transmission
    reg [9:0] tx_shift_reg;     // Shift register for transmission
    reg transmitting;           // Indicates if currently transmitting

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1;              // Idle state for UART is high
            tx_done <= 0;
            bit_index <= 0;
            transmitting <= 0;
        end else begin
            if (start_tx && !transmitting) begin
                // Load the shift register with start bit, data, and stop bit
                tx_shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit is high (1)
                transmitting <= 1;
                bit_index <= 0;
                tx_done <= 0;
            end else if (transmitting) begin
                if (bit_index < 10) begin
                    tx <= tx_shift_reg[0]; // Transmit the LSB
                    tx_shift_reg <= tx_shift_reg >> 1; // Shift right
                    bit_index <= bit_index + 1;
                end else begin
                    tx_done <= 1; // Transmission complete
                    transmitting <= 0;
                    tx <= 1; // Idle state
                end
            end
        end
    end
endmodule
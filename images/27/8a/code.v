module uart_transmitter (
    input wire clk,             // Clock input
    input wire reset,           // Reset input
    input wire [7:0] data_in,   // 8-bit data input
    input wire transmit,        // Transmit enable signal
    output reg tx,             // Transmitted data output
    output reg busy            // Busy signal indicating transmission in progress
);
    reg [3:0] bit_counter;     // Counts the number of bits transmitted
    reg [9:0] shift_reg;       // Shift register for data transmission
    parameter BAUD_RATE = 9600; // Baud rate parameter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1;              // Idle state for UART is high
            busy <= 0;
            bit_counter <= 0;
            shift_reg <= 10'b1111111111; // Default idle state
        end else if (transmit && !busy) begin
            busy <= 1;
            bit_counter <= 0;
            shift_reg <= {1'b1, data_in, 1'b0}; // Start bit + data + stop bit
        end else if (busy) begin
            tx <= shift_reg[bit_counter];
            bit_counter <= bit_counter + 1;
            if (bit_counter == 10) begin
                busy <= 0; // Transmission complete
            end
        end
    end
endmodule
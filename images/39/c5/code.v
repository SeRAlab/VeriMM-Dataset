module uart_transmitter (
    input wire clk,              // Clock input
    input wire reset,            // Reset signal
    input wire enable,           // Enable signal for transmission
    input wire [7:0] data_in,    // 8-bit data input
    output reg tx                // Serial data output
);

    parameter BAUD_RATE = 9600;  // Baud rate
    parameter CLOCK_FREQ = 50000000; // Clock frequency
    parameter BIT_PERIOD = CLOCK_FREQ / BAUD_RATE; // Clock cycles per bit

    reg [3:0] bit_index;          // Current bit index
    reg [15:0] clk_counter;        // Clock counter
    reg sending;                  // Sending flag

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1;              // Idle state (high)
            bit_index <= 0;
            clk_counter <= 0;
            sending <= 0;
        end else if (enable && !sending) begin
            sending <= 1;
            tx <= 0;              // Start bit
            bit_index <= 0;
            clk_counter <= 0;
        end else if (sending) begin
            if (clk_counter < BIT_PERIOD - 1) begin
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
                if (bit_index < 8) begin
                    tx <= data_in[bit_index]; // Transmit data bits
                    bit_index <= bit_index + 1;
                end else if (bit_index == 8) begin
                    tx <= 1;         // Stop bit
                    bit_index <= bit_index + 1;
                end else begin
                    sending <= 0;    // Transmission finished
                end
            end
        end
    end
endmodule
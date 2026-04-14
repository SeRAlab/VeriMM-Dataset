module uart_transmitter (
    input clk,               // Clock signal
    input start,             // Start signal
    input [7:0] data_in,     // 8-bit data input
    output reg tx,           // Serial output
    output reg busy          // Indicates if the transmitter is busy
);

    reg [3:0] bit_index;     // Index for which bit is being sent
    reg [7:0] data;          // Register to hold data
    reg [15:0] clk_div;      // Clock divider for baud rate
    parameter BAUD_RATE_DIV = 16; // Adjust this for desired baud rate

    always @(posedge clk) begin
        if (start && !busy) begin
            busy <= 1;       // Set busy flag
            data <= data_in; // Load data to send
            bit_index <= 0;  // Reset bit index
            tx <= 0;         // Start bit (active low)
            clk_div <= 0;    // Reset clock divider
        end else if (busy) begin
            clk_div <= clk_div + 1;
            if (clk_div == BAUD_RATE_DIV) begin
                clk_div <= 0; // Reset clock divider
                if (bit_index < 8) begin
                    tx <= data[bit_index]; // Send data bits
                    bit_index <= bit_index + 1; // Move to next bit
                end else begin
                    tx <= 1; // Stop bit (inactive state)
                    busy <= 0; // Clear busy flag after sending
                end
            end
        end
    end

endmodule
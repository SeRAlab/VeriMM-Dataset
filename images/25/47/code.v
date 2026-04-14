module uart_transmitter (
    input wire clk,         // Clock input
    input wire start,       // Start signal to initiate transmission
    input wire [7:0] data,  // 8-bit data input
    output reg tx           // Serial transmit output
);
    reg [3:0] bit_index;    // To keep track of the bit being sent
    reg [10:0] shift_reg;    // Shift register to hold start, data, and stop bits
    reg sending;            // Flag to indicate if transmission is ongoing

    always @(posedge clk) begin
        if (start && !sending) begin
            shift_reg <= {1'b1, data, 1'b0}; // Load the shift register with stop, data, start bits
            bit_index <= 0;                  // Reset bit index
            sending <= 1;                    // Set sending flag
        end else if (sending) begin
            tx <= shift_reg[bit_index];      // Output the current bit
            bit_index <= bit_index + 1;      // Move to the next bit
            if (bit_index == 10) begin        // All bits sent
                sending <= 0;                 // Reset sending flag
            end
        end
    end
endmodule
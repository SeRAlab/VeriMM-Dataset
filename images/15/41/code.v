module uart_controller (
    input clk,            // Clock input
    input rst_n,         // Active low reset
    input start,         // Start signal
    input [7:0] data_in, // 8-bit parallel data input
    output reg tx        // Serial data output
);
    reg [3:0] bit_count; // To count the number of bits transmitted
    reg [9:0] shift_reg; // Shift register to hold the data to be transmitted
    reg transmitting;    // Flag to indicate transmission state

    // State machine logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1; // Idle state is high
            bit_count <= 0;
            transmitting <= 0;
        end else if (start && !transmitting) begin
            // Load the shift register with the start bit, data bits, and stop bit
            shift_reg <= {1'b1, data_in, 1'b0}; // stop bit, data, start bit
            bit_count <= 0;
            transmitting <= 1;
        end else if (transmitting) begin
            if (bit_count < 10) begin
                tx <= shift_reg[bit_count]; // Transmit current bit
                bit_count <= bit_count + 1;
            end else begin
                transmitting <= 0; // Transmission complete
            end
        end
    end
endmodule
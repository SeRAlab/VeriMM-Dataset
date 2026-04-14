module uart_transmitter (
    input wire clk,               // Clock input
    input wire reset,             // Reset input
    input wire start_tx,          // Start transmission signal
    input wire [7:0] data_in,     // 8-bit data input
    output reg tx,                // Transmit output
    output reg busy               // Transmission status
);

    reg [3:0] bit_index;          // Index to track which bit to send
    reg [10:0] shift_reg;         // Shift register to hold the frame (start + data + stop)
    reg [15:0] baud_counter;      // Counter for baud rate

    localparam BAUD_DIV = 16'd104; // Example baud rate division factor for 9600bps
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1;            // Idle state is high
            busy <= 1'b0;
            bit_index <= 4'd0;
            baud_counter <= 16'd0;
            shift_reg <= 11'b0;
        end else begin
            if (start_tx && !busy) begin
                // Load the shift register with the start bit, data, and stop bit
                shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit, data, start bit
                busy <= 1'b1;                     // Set busy flag
                bit_index <= 4'd0;                // Start with the first bit
                baud_counter <= 16'd0;             // Reset baud counter
            end else if (busy) begin
                if (baud_counter < BAUD_DIV) begin
                    baud_counter <= baud_counter + 1; // Wait for the baud rate clock
                end else begin
                    baud_counter <= 16'd0; // Reset baud counter
                    if (bit_index < 11) begin
                        tx <= shift_reg[0]; // Send the least significant bit
                        shift_reg <= shift_reg >> 1; // Shift right
                        bit_index <= bit_index + 1; // Move to the next bit
                    end else begin
                        busy <= 1'b0;        // Transmission complete
                        tx <= 1'b1;          // Set idle state
                    end
                end
            end
        end
    end
endmodule
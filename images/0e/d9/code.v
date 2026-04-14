module uart_tx (
    input clk,
    input send,
    input [7:0] data,
    output reg tx
);
    reg [3:0] bit_count; // Count the number of bits transmitted
    reg [10:0] shift_reg; // Shift register to hold the complete frame
    reg transmitting; // State of transmitter
    reg [15:0] baud_counter; // Baud rate counter

    parameter CLOCK_FREQ = 1000000; // 1 MHz
    parameter BAUD_RATE = 9600;
    parameter BAUD_LIMIT = CLOCK_FREQ / BAUD_RATE;

    always @(posedge clk) begin
        if (send && !transmitting) begin
            transmitting <= 1; // Start transmission
            shift_reg <= {1'b1, data, 1'b0}; // Prepare the data with start and stop bits
            bit_count <= 0; // Reset bit counter
            baud_counter <= 0; // Reset baud counter
        end else if (transmitting) begin
            if (baud_counter < BAUD_LIMIT - 1) begin
                baud_counter <= baud_counter + 1; // Increment baud counter
            end else begin
                baud_counter <= 0; // Reset baud counter
                tx <= shift_reg[0]; // Output the current bit
                shift_reg <= shift_reg >> 1; // Shift right to get the next bit
                bit_count <= bit_count + 1; // Increment bit counter

                if (bit_count == 10) begin // 10 bits transmitted (1 start + 8 data + 1 stop)
                    transmitting <= 0; // End transmission
                end
            end
        end
    end
endmodule
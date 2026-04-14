module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire send,
    output reg tx,
    output reg ready
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // 50 MHz clock
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;

    reg [3:0] bit_counter;
    reg [9:0] shift_reg;
    reg [15:0] baud_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1; // Idle state
            ready <= 1;
            baud_counter <= 0;
            bit_counter <= 0;
        end else begin
            if (send && ready) begin
                // Load shift register with start bit, data bits, and stop bit
                shift_reg <= {1'b1, data_in, 1'b0}; // stop bit, data, start bit
                bit_counter <= 0;
                ready <= 0; // Not ready to send new data
                baud_counter <= 0; // Reset baud counter
            end

            if (!ready) begin
                if (baud_counter < BIT_PERIOD - 1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
                    if (bit_counter < 10) begin
                        tx <= shift_reg[0]; // Send LSB first
                        shift_reg <= shift_reg >> 1; // Shift right
                        bit_counter <= bit_counter + 1;
                    end else begin
                        tx <= 1; // Back to idle state
                        ready <= 1; // Ready for next transmission
                    end
                end
            end
        end
    end
endmodule
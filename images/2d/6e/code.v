module uart_transmitter(
    input wire clk,               // System clock
    input wire rst_n,             // Active low reset
    input wire tx_en,             // Transmission enable
    input wire [7:0] data_in,     // 8-bit data input
    output reg tx_out             // Serial data output
);
    reg [3:0] bit_cnt;            // Bit counter
    reg [9:0] shift_reg;          // Shift register including start and stop bits
    reg transmitting;             // Transmitting flag

    // State machine for transmission
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_out <= 1;          // Idle state is high
            bit_cnt <= 0;
            shift_reg <= 0;
            transmitting <= 0;
        end else if (tx_en && !transmitting) begin
            // Prepare to transmit data
            shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit, data, start bit
            bit_cnt <= 0;
            transmitting <= 1;
        end else if (transmitting) begin
            // Shift out data
            tx_out <= shift_reg[0];    // Output least significant bit
            shift_reg <= shift_reg >> 1; // Shift right
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 9) begin   // When all bits are transmitted
                transmitting <= 0;    // Reset transmitting flag
            end
        end
    end
endmodule
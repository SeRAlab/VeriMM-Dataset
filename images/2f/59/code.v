module uart_transmitter (
    input wire clk,
    input wire transmit_enable,
    input wire [7:0] data_in,
    output reg tx
);
    reg [3:0] state;
    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit

    parameter IDLE = 0, START_BIT = 1, DATA_BITS = 2, STOP_BIT = 3;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (transmit_enable) begin
                    shift_reg <= {1'b1, data_in, 1'b0}; // Load data with start and stop bits
                    tx <= 1'b0; // Start bit
                    bit_count <= 0;
                    state <= START_BIT;
                end
            end

            START_BIT: begin
                if (bit_count < 10) begin
                    tx <= shift_reg[0]; // Send the current bit
                    shift_reg <= shift_reg >> 1; // Shift right for next bit
                    bit_count <= bit_count + 1;
                    if (bit_count == 9) begin
                        state <= STOP_BIT;
                    end
                end
            end
            
            STOP_BIT: begin
                tx <= 1'b1; // Stop bit
                state <= IDLE; // Return to idle
            end
        endcase
    end
endmodule
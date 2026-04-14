module uart_transmitter (
    input wire clk,                // Baud rate clock
    input wire rst,                // Reset signal
    input wire [7:0] data_in,     // Data to transmit
    input wire start_transmit,     // Signal to start transmission
    output reg tx,                 // Transmitted serial data
    output reg busy                // Indicates transmitter is busy
);

    reg [3:0] state;               // State machine current state
    reg [3:0] bit_index;           // Current bit index
    reg [10:0] shift_reg;          // Shift register for UART frame

    localparam IDLE = 4'b0000;
    localparam START_BIT = 4'b0001;
    localparam TRANSMIT = 4'b0010;
    localparam STOP_BIT = 4'b0011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            busy <= 0;
            tx <= 1; // Idle state for tx is high
            bit_index <= 0;
            shift_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_transmit) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit, data, start bit
                        bit_index <= 0;
                        busy <= 1;
                        state <= START_BIT;
                    end
                end

                START_BIT: begin
                    tx <= 0; // Start bit
                    state <= TRANSMIT;
                end

                TRANSMIT: begin
                    if (bit_index < 8) begin
                        tx <= shift_reg[bit_index]; // Transmit next bit
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP_BIT; // Go to stop bit
                    end
                end

                STOP_BIT: begin
                    tx <= 1; // Stop bit
                    busy <= 0; // Transmission complete
                    state <= IDLE; // Reset to IDLE
                end
            endcase
        end
    end
endmodule
module uart_transmitter (
    input wire clk,       // Clock signal
    input wire send,      // Signal to send data
    input wire [7:0] data, // 8-bit data input
    output reg tx        // Transmit output
);
    reg [3:0] state;     // State of the FSM
    reg [3:0] bit_index; // Current bit index
    reg [11:0] baud_count; // Baud rate counter

    parameter IDLE = 4'b0000, START_BIT = 4'b0001, DATA_BITS = 4'b0010, STOP_BIT = 4'b0011;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx <= 1; // Idle state, tx high
                if (send) begin
                    state <= START_BIT; // Move to start bit
                    bit_index <= 0; // Reset bit index
                    baud_count <= 0; // Reset baud count
                end
            end
            
            START_BIT: begin
                tx <= 0; // Start bit is low
                if (baud_count == 10416) begin // Wait for one bit duration (1 MHz clock for 9600 baud)
                    baud_count <= 0; // Reset baud count
                    state <= DATA_BITS; // Move to data bits
                end else begin
                    baud_count <= baud_count + 1; 
                end
            end
            
            DATA_BITS: begin
                tx <= data[bit_index]; // Transmit data bit
                if (baud_count == 10416) begin // Wait for one bit duration
                    baud_count <= 0; // Reset baud count
                    if (bit_index == 7) begin
                        state <= STOP_BIT; // Move to stop bit
                    end else begin
                        bit_index <= bit_index + 1; // Move to next bit
                    end
                end else begin
                    baud_count <= baud_count + 1; 
                end
            end

            STOP_BIT: begin
                tx <= 1; // Stop bit is high
                if (baud_count == 10416) begin // Wait for one bit duration
                    baud_count <= 0; // Reset baud count
                    state <= IDLE; // Back to idle
                end else begin
                    baud_count <= baud_count + 1; 
                end
            end

            default: state <= IDLE; // Default state
        endcase
    end
endmodule
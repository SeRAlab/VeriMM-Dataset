module uart_receiver (
    input wire clk,           // System clock
    input wire rst,           // Reset signal
    input wire rx,           // UART receive line
    output reg [7:0] data,   // Received data
    output reg data_ready     // Data ready signal
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // Example clock frequency
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;
    
    reg [3:0] state;                // State machine state
    reg [9:0] shift_reg;            // Shift register for receiving bits
    reg [15:0] bit_counter;          // Bit counter for timing
    reg [3:0] bit_index;             // Current bit index
    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data <= 8'b0;
            data_ready <= 0;
            bit_counter <= 0;
            bit_index <= 0;
        end else begin
            case(state)
                IDLE: begin
                    data_ready <= 0;
                    if (rx == 0) begin // Start bit detected
                        state <= START;
                        bit_counter <= 0;
                    end
                end
                START: begin
                    if (bit_counter < BIT_PERIOD - 1) begin
                        bit_counter <= bit_counter + 1;
                    end else begin
                        bit_counter <= 0;
                        state <= DATA;
                    end
                end
                DATA: begin
                    if (bit_counter < BIT_PERIOD - 1) begin
                        bit_counter <= bit_counter + 1;
                    end else begin
                        bit_counter <= 0;
                        shift_reg <= {rx, shift_reg[9:1]};
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            data <= shift_reg[8:1]; // Store received data
                            state <= STOP;
                            bit_index <= 0;
                        end
                    end
                end
                STOP: begin
                    if (bit_counter < BIT_PERIOD - 1) begin
                        bit_counter <= bit_counter + 1;
                    end else begin
                        data_ready <= 1; // Data is ready
                        state <= IDLE; // Go back to IDLE
                    end
                end
            endcase
        end
    end
endmodule
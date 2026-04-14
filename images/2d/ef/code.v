module uart_receiver (
    input wire clk,            // System clock
    input wire rst,            // Reset signal
    input wire rx,             // Serial input
    output reg [7:0] data_out, // Parallel output data
    output reg data_ready      // Signal when data is ready
);

    parameter BAUD_RATE = 9600; // Configurable Baud Rate
    parameter CLOCK_FREQ = 50000000; // Example clock frequency
    localparam CLOCK_DIV = CLOCK_FREQ / BAUD_RATE;

    reg [3:0] state;           // State variable
    reg [9:0] shift_reg;       // Shift register for data
    reg [15:0] bit_count;      // Bit counter
    reg [15:0] clock_count;    // Clock divider count

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 8'b0;
            data_ready <= 0;
            bit_count <= 0;
            clock_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    data_ready <= 0;
                    if (rx == 0) begin // Start bit detected
                        state <= START;
                        clock_count <= 0;
                    end
                end
                
                START: begin
                    if (clock_count < CLOCK_DIV/2) begin
                        clock_count <= clock_count + 1;
                    end else begin
                        clock_count <= 0;
                        state <= DATA;
                        bit_count <= 0;
                        shift_reg <= 0;
                    end
                end
                
                DATA: begin
                    if (clock_count < CLOCK_DIV) begin
                        clock_count <= clock_count + 1;
                    end else begin
                        clock_count <= 0;
                        shift_reg <= {rx, shift_reg[9:1]}; // Shift in data
                        bit_count <= bit_count + 1;
                        if (bit_count == 8) begin
                            state <= STOP; // Go to stop state after 8 bits
                        end
                    end
                end
                
                STOP: begin
                    if (clock_count < CLOCK_DIV) begin
                        clock_count <= clock_count + 1;
                    end else begin
                        data_out <= shift_reg[8:1]; // Output the received data
                        data_ready <= 1; // Data is ready
                        state <= IDLE; // Go back to idle
                    end
                end
                
                default: state <= IDLE; // In case of unexpected state
            endcase
        end
    end
endmodule
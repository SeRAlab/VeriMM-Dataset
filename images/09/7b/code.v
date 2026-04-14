module uart_transmitter(
    input wire clk,              // Clock input
    input wire rst,              // Reset input
    input wire [7:0] data_in,    // 8-bit data input
    input wire start_transmit,    // Signal to start transmission
    output reg tx,               // Serial output
    output reg busy              // Transmission status
);

parameter BAUD_RATE = 9600;       // Set baud rate
parameter CLOCK_FREQ = 50000000;  // Set clock frequency
localparam CLOCK_DIV = CLOCK_FREQ / (BAUD_RATE * 16); // Clock divider

reg [3:0] state;                  // State variable
reg [3:0] bit_index;              // Index to track the bit being transmitted
reg [15:0] clk_counter;           // Clock counter for baud rate generation

localparam IDLE = 4'b0000,
           START_BIT = 4'b0001,
           TRANSMITTING = 4'b0010,
           STOP_BIT = 4'b0011;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx <= 1;
        busy <= 0;
        state <= IDLE;
        clk_counter <= 0;
        bit_index <= 0;
    end else begin
        case (state)
            IDLE: begin
                tx <= 1; // Idle state is high
                busy <= 0;
                if (start_transmit) begin
                    state <= START_BIT;
                    busy <= 1;
                end
            end
            START_BIT: begin
                tx <= 0; // Start bit is low
                if (clk_counter < CLOCK_DIV) begin
                    clk_counter <= clk_counter + 1;
                end else begin
                    clk_counter <= 0;
                    state <= TRANSMITTING;
                    bit_index <= 0;
                end
            end
            TRANSMITTING: begin
                tx <= data_in[bit_index]; // Transmit each data bit
                if (clk_counter < CLOCK_DIV) begin
                    clk_counter <= clk_counter + 1;
                end else begin
                    clk_counter <= 0;
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP_BIT;
                    end
                end
            end
            STOP_BIT: begin
                tx <= 1; // Stop bit is high
                if (clk_counter < CLOCK_DIV) begin
                    clk_counter <= clk_counter + 1;
                end else begin
                    clk_counter <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule
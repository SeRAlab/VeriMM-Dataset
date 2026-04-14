module spi_master (
    input wire clk,            // System clock
    input wire reset_n,        // Active low reset
    input wire [7:0] data_in,  // Data to send to slave
    input wire start,          // Start signal to begin transmission
    output reg mosi,          // Master Out Slave In
    output reg sclk,          // SPI Clock
    output reg cs_n,          // Chip Select (active low)
    output reg [7:0] data_out, // Data received from slave
    output reg done           // Transmission done flag
);

    reg [2:0] state;            // State machine
    reg [3:0] bit_cnt;          // Bit counter
    reg [7:0] shift_reg;        // Shift register for data

    // State encoding
    localparam IDLE = 3'b000,
               START = 3'b001,
               TRANSFER = 3'b010,
               DONE = 3'b011;

    // SCLK generation
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sclk <= 1'b0;
        end else begin
            sclk <= ~sclk;
        end
    end

    // State machine
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            cs_n <= 1'b1; // Chip select high (inactive)
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        cs_n <= 1'b0; // Activate chip select
                        shift_reg <= data_in; // Load data to send
                        bit_cnt <= 4'b0; // Initialize bit counter
                        state <= START;
                    end
                end
                START: begin
                    state <= TRANSFER;
                end
                TRANSFER: begin
                    if (bit_cnt < 8) begin
                        mosi <= shift_reg[7]; // Send MSB first
                        shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    cs_n <= 1'b1; // Deactivate chip select
                    done <= 1'b1; // Set done flag
                    state <= IDLE; // Return to idle
                end
            endcase
        end
    end

endmodule
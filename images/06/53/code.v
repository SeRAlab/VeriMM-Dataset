module spi_master (
    input wire clk,              // System clock
    input wire rst,              // Asynchronous reset
    input wire start,            // Start transmission signal
    input wire [7:0] data_in,    // 8-bit data to transmit
    output reg mosi,             // Master out slave in
    output reg sclk,             // Serial clock
    output reg done              // Transmission done signal
);
    reg [3:0] bit_counter;       // Count the bits transmitted
    reg [7:0] data_reg;          // Register for data to transmit
    reg state;                   // State of the transmission

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mosi <= 1'b0;
            sclk <= 1'b0;
            done <= 1'b0;
            bit_counter <= 4'b0000;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // Idle state
                    done <= 1'b0;
                    if (start) begin
                        data_reg <= data_in; // Load data to transmit
                        bit_counter <= 4'b0000; // Reset bit counter
                        state <= 1'b1; // Move to next state
                    end
                end
                1'b1: begin // Transmitting state
                    if (bit_counter < 4'b1000) begin
                        sclk <= ~sclk; // Toggle the clock
                        if (sclk) begin
                            mosi <= data_reg[7]; // Shift out the MSB
                            data_reg <= {data_reg[6:0], 1'b0}; // Shift left
                            bit_counter <= bit_counter + 1; // Increment bit counter
                        end
                    end else begin
                        done <= 1'b1; // Transmission complete
                        state <= 1'b0; // Return to idle
                    end
                end
            endcase
        end
    end
endmodule
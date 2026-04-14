module spi_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg cs,
    output reg sck,
    output reg mosi,
    output reg done
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg state;

    parameter IDLE = 1'b0, TRANSFER = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cs <= 1;
            sck <= 0;
            mosi <= 0;
            done <= 0;
            bit_count <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        cs <= 0; // Activate chip select
                        shift_reg <= data_in;
                        bit_count <= 8; // Start transferring 8 bits
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    if (bit_count > 0) begin
                        sck <= ~sck; // Toggle clock
                        if (sck) begin
                            mosi <= shift_reg[bit_count - 1]; // Send MSB first
                        end
                        if (~sck) begin
                            bit_count <= bit_count - 1; // Decrement bit count
                        end
                    end else begin
                        cs <= 1; // Deactivate chip select
                        done <= 1; // Signal that transfer is done
                        state <= IDLE; // Go back to idle state
                    end
                end
            endcase
        end
    end
endmodule
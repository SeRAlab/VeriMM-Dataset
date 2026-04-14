module uart_tx (
    input clk,              // System clock
    input reset,            // Active-high reset
    input enable,           // Transmission enable
    input [7:0] data_in,    // 8-bit data input
    output reg tx,          // Transmitted output
    output reg done         // Transmission done signal
);

    reg [3:0] bit_count;    // Bit counter
    reg [10:0] shift_reg;    // Shift register (8 data + start + stop)
    reg state;              // State variable

    parameter IDLE = 1'b0, TRANSMIT = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1;          // Idle state is high
            done <= 0;
            bit_count <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (enable) begin
                        // Load the shift register with start bit, data, stop bit
                        shift_reg <= {1'b1, data_in, 1'b0}; // Start bit + Data + Stop bit
                        bit_count <= 0; // Reset the bit count
                        state <= TRANSMIT; // Move to transmit state
                        done <= 0; // Reset done signal
                    end
                end

                TRANSMIT: begin
                    if (bit_count < 11) begin
                        tx <= shift_reg[0]; // Transmit the current bit
                        shift_reg <= shift_reg >> 1; // Shift right
                        bit_count <= bit_count + 1; // Increment bit count
                    end else begin
                        done <= 1; // Signal that transmission is complete
                        state <= IDLE; // Go back to idle state
                    end
                end
            endcase
        end
    end
endmodule
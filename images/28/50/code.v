module uart_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire tx_enable,
    output reg tx,
    output reg ready
);

    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    reg state;

    parameter IDLE = 1'b0;
    parameter TRANSMITTING = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1; // Idle state for UART is high
            ready <= 1;
            bit_count <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (tx_enable && ready) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // Prepare to send start bit + data + stop bit
                        bit_count <= 0;
                        tx <= 0; // Start bit
                        ready <= 0; // Not ready for new data
                        state <= TRANSMITTING;
                    end
                end
                TRANSMITTING: begin
                    if (bit_count < 10) begin
                        tx <= shift_reg[bit_count]; // Send one bit
                        bit_count <= bit_count + 1;
                    end else begin
                        tx <= 1; // Stop bit
                        ready <= 1; // Ready for new data
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
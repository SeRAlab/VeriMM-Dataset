module uart_tx (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire send,
    output reg tx,
    output reg busy
);
    reg [3:0] state;
    reg [2:0] bit_count;
    reg [9:0] shift_reg;

    localparam IDLE = 4'b0000,
               START = 4'b0001,
               DATA = 4'b0010,
               STOP = 4'b0011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
            bit_count <= 0;
            tx <= 1; // Idle state of UART is high
        end else begin
            case (state)
                IDLE: begin
                    if (send) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit, data, start bit
                        bit_count <= 0;
                        busy <= 1;
                        state <= START;
                    end
                end
                START: begin
                    tx <= 0; // Start bit
                    state <= DATA;
                end
                DATA: begin
                    tx <= shift_reg[bit_count + 1]; // Transmit bit
                    bit_count <= bit_count + 1;
                    if (bit_count == 7) begin
                        state <= STOP; // Move to stop after 8 data bits
                    end
                end
                STOP: begin
                    tx <= 1; // Stop bit
                    busy <= 0;
                    state <= IDLE; // Return to idle
                end
            endcase
        end
    end
endmodule
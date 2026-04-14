module uart_transmitter (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire start_tx,
    output reg tx,
    output reg busy
);
    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 start + 8 data + 1 stop
    reg state; // 0: idle, 1: transmitting
    parameter IDLE = 1'b0, TRANSMIT = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            busy <= 0;
            state <= IDLE;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_tx && !busy) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // start bit + data + stop bit
                        bit_count <= 0;
                        busy <= 1;
                        state <= TRANSMIT;
                    end
                end
                TRANSMIT: begin
                    if (bit_count < 10) begin
                        tx <= shift_reg[0]; // send LSB first
                        shift_reg <= {1'b1, shift_reg[9:1]}; // shift right
                        bit_count <= bit_count + 1;
                    end else begin
                        tx <= 1; // idle state
                        busy <= 0;
                        state <= IDLE; // back to idle
                    end
                end
            endcase
        end
    end
endmodule
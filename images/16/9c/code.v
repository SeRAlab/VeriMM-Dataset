module uart_tx (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);
    reg [3:0] bit_counter;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    reg [1:0] state; // 0: idle, 1: sending, 2: done

    parameter IDLE = 0, SENDING = 1, DONE = 2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1; // Idle state
            busy <= 1'b0;
            state <= IDLE;
            bit_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (enable) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // Start with stop bit 1, data bits, start bit 0
                        bit_counter <= 0;
                        busy <= 1'b1;
                        state <= SENDING;
                    end
                end

                SENDING: begin
                    if (bit_counter < 10) begin
                        tx <= shift_reg[bit_counter]; // Send the current bit
                        bit_counter <= bit_counter + 1;
                    end else begin
                        busy <= 1'b0;
                        state <= DONE;
                    end
                end

                DONE: begin
                    tx <= 1'b1; // Return to idle state
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
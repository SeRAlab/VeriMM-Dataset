module uart_tx (
    input clk,
    input reset,
    input [7:0] data_in,
    input send,
    output reg tx,
    output reg transmitting
);
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] state, next_state;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            transmitting <= 0;
            tx <= 1; // idle state is high
            bit_count <= 0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                if (bit_count < 8) begin
                    tx <= shift_reg[0];
                    shift_reg <= {1'b0, shift_reg[7:1]}; // shift right
                    bit_count <= bit_count + 1;
                end
            end
            if (state == STOP) begin
                tx <= 1; // stop bit
                transmitting <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (send) begin
                    next_state = START;
                    shift_reg = data_in;
                    bit_count = 0;
                    transmitting = 1;
                end else begin
                    next_state = IDLE;
                end
            end
            START: begin
                tx = 0; // start bit
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 8) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
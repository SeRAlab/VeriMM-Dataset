module uart_receiver (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] data_out,
    output reg data_ready
);
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] state, next_state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 8'b0;
            data_ready <= 0;
            bit_count <= 0;
        end else begin
            state <= next_state;
            if (next_state == DATA) begin
                data_out[bit_count] <= serial_in;
                bit_count <= bit_count + 1;
            end else if (next_state == STOP) begin
                data_ready <= 1;
            end
            if (next_state == IDLE) begin
                bit_count <= 0;
                data_ready <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (serial_in == 0) // start bit detected
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
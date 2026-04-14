module uart_receiver(
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] data,
    output reg data_valid
);

    reg [3:0] bit_index;
    reg [2:0] state;
    reg [7:0] rx_buffer;
    parameter IDLE = 3'b000, START = 3'b001, READING = 3'b010, STOP = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_index <= 0;
            data <= 0;
            data_valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (rx == 0) begin  // Start bit detected
                        state <= START;
                    end
                end
                START: begin
                    state <= READING;
                    bit_index <= 0;
                end
                READING: begin
                    rx_buffer[bit_index] <= rx;
                    bit_index <= bit_index + 1;
                    if (bit_index == 7) begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    if (rx == 1) begin  // Stop bit detected
                        data <= rx_buffer;
                        data_valid <= 1;
                    end
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
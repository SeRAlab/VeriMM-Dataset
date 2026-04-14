module uart_transmitter (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    output reg tx
);
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] state = IDLE;
    reg [3:0] bit_count = 0;
    reg [7:0] data_buffer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1'b1; // Idle state for UART is high
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= START;
                        data_buffer <= data_in;
                        tx <= 1'b0; // Start bit
                    end
                end
                START: begin
                    state <= DATA;
                    bit_count <= 0;
                end
                DATA: begin
                    if (bit_count < 8) begin
                        tx <= data_buffer[bit_count];
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= STOP;
                        tx <= 1'b1; // Transitions to stop bit
                    end
                end
                STOP: begin
                    tx <= 1'b1; // Stop bit
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
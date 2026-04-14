module uart_transmitter (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);
    reg [3:0] state;
    reg [3:0] bit_index;
    reg [7:0] data_buffer;

    localparam IDLE = 0;
    localparam START_BIT = 1;
    localparam DATA_BITS = 2;
    localparam STOP_BIT = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            busy <= 0;
            tx <= 1; // idle state for UART is high
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (start) begin
                        data_buffer <= data_in;
                        bit_index <= 0;
                        tx <= 0; // start bit
                        state <= START_BIT;
                        busy <= 1;
                    end
                end
                START_BIT: begin
                    state <= DATA_BITS;
                end
                DATA_BITS: begin
                    if (bit_index < 8) begin
                        tx <= data_buffer[bit_index];
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP_BIT;
                    end
                end
                STOP_BIT: begin
                    tx <= 1; // stop bit
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
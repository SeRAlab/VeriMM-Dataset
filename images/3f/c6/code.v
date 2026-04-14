module uart_transmitter(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg tx,
    output reg tx_done
);
    reg [3:0] state;
    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 start + 8 data + 1 stop
    parameter IDLE = 0, START_BIT = 1, DATA_BITS = 2, STOP_BIT = 3, DONE = 4;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1; // idle state for tx is high
            tx_done <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_done <= 0;
                    if (start) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // start bit + data + stop bit
                        bit_count <= 0;
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    tx <= shift_reg[bit_count];
                    if (bit_count == 9) begin // 1 start bit transmitted
                        state <= DATA_BITS;
                        bit_count <= 0;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                DATA_BITS: begin
                    tx <= shift_reg[bit_count];
                    if (bit_count == 8) begin // all data bits transmitted
                        state <= STOP_BIT;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                STOP_BIT: begin
                    tx <= 1; // stop bit
                    state <= DONE;
                end
                DONE: begin
                    tx_done <= 1;
                    state <= IDLE; // reset to idle after done
                end
            endcase
        end
    end
endmodule
module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire start,
    output reg tx,
    output reg busy
);
    reg [3:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;

    localparam IDLE = 0, START_BIT = 1, DATA_BITS = 2, STOP_BIT = 3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1; // Idle state for TX line
            busy <= 0;
            state <= IDLE;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start && !busy) begin
                        busy <= 1;
                        shift_reg <= data_in;
                        tx <= 0; // Start bit
                        state <= START_BIT;
                        bit_cnt <= 0;
                    end
                end
                START_BIT: begin
                    // Wait for 1 clock cycle
                    state <= DATA_BITS;
                end
                DATA_BITS: begin
                    tx <= shift_reg[bit_cnt]; // Transmit data bits
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) begin
                        state <= STOP_BIT;
                    end
                end
                STOP_BIT: begin
                    tx <= 1; // Stop bit
                    busy <= 0;
                    state <= IDLE; // Return to IDLE
                end
            endcase
        end
    end
endmodule
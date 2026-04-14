module uart_tx (
    input wire clk,
    input wire rst,
    input wire start_tx,
    input wire [7:0] data_in,
    output reg tx,
    output reg tx_ready
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // 50 MHz
    localparam CLOCK_DIVIDER = CLOCK_FREQ / BAUD_RATE;

    reg [3:0] state;
    reg [7:0] shift_reg;
    reg [15:0] clk_div;
    reg [3:0] bit_index;

    localparam IDLE = 0;
    localparam START_BIT = 1;
    localparam DATA_BITS = 2;
    localparam STOP_BIT = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1; // idle state is high
            tx_ready <= 1;
            clk_div <= 0;
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1; // idle high
                    tx_ready <= 1;
                    if (start_tx) begin
                        shift_reg <= data_in;
                        state <= START_BIT;
                        clk_div <= 0;
                        bit_index <= 0;
                    end
                end
                START_BIT: begin
                    clk_div <= clk_div + 1;
                    if (clk_div == CLOCK_DIVIDER / 2) begin
                        tx <= 0; // start bit
                    end else if (clk_div == CLOCK_DIVIDER) begin
                        clk_div <= 0;
                        state <= DATA_BITS;
                    end
                end
                DATA_BITS: begin
                    clk_div <= clk_div + 1;
                    if (clk_div == CLOCK_DIVIDER / 2) begin
                        tx <= shift_reg[bit_index]; // output current bit
                    end else if (clk_div == CLOCK_DIVIDER) begin
                        clk_div <= 0;
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) begin
                            state <= STOP_BIT; // go to stop bit after 8 bits
                        end
                    end
                end
                STOP_BIT: begin
                    clk_div <= clk_div + 1;
                    if (clk_div == CLOCK_DIVIDER / 2) begin
                        tx <= 1; // stop bit
                    end else if (clk_div == CLOCK_DIVIDER) begin
                        clk_div <= 0;
                        state <= IDLE; // return to idle state
                        tx_ready <= 1; // transmission complete
                    end
                end
            endcase
        end
    end
endmodule
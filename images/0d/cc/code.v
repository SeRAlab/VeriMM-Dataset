module uart_tx (
    input clk,
    input reset,
    input [7:0] data_in,
    input start,
    output reg tx,
    output reg tx_complete
);
    parameter CLOCK_DIVIDER = 16; // Adjust for baud rate
    reg [3:0] bit_count;
    reg [3:0] state;
    reg [10:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    reg [3:0] clk_div;

    localparam IDLE = 0, START_BIT = 1, DATA_BITS = 2, STOP_BIT = 3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1;
            tx_complete <= 0;
            state <= IDLE;
            clk_div <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_complete <= 0;
                    if (start) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // Load data with start and stop bits
                        clk_div <= 0;
                        bit_count <= 0;
                        state <= START_BIT;
                    end
                end

                START_BIT: begin
                    tx <= 0; // Send start bit
                    if (clk_div == CLOCK_DIVIDER - 1) begin
                        clk_div <= 0;
                        state <= DATA_BITS;
                    end else begin
                        clk_div <= clk_div + 1;
                    end
                end

                DATA_BITS: begin
                    tx <= shift_reg[bit_count + 1]; // Send the current bit
                    if (clk_div == CLOCK_DIVIDER - 1) begin
                        clk_div <= 0;
                        if (bit_count == 8) begin
                            state <= STOP_BIT;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        clk_div <= clk_div + 1;
                    end
                end

                STOP_BIT: begin
                    tx <= 1; // Send stop bit
                    if (clk_div == CLOCK_DIVIDER - 1) begin
                        clk_div <= 0;
                        tx_complete <= 1; // Transmission complete
                        state <= IDLE;
                    end else begin
                        clk_div <= clk_div + 1;
                    end
                end
            endcase
        end
    end
endmodule
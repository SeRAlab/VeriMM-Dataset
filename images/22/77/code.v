module spi_master (
    input clk,
    input rst,
    input start,
    input [7:0] mosi,
    output reg miso,
    output reg sclk,
    output reg cs
);
    reg [2:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data_reg;

    localparam IDLE = 3'b000, 
               SEND = 3'b001, 
               SCLK_HIGH = 3'b010, 
               SCLK_LOW = 3'b011, 
               RECEIVE = 3'b100, 
               DONE = 3'b101;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sclk <= 0;
            cs <= 1;
            bit_cnt <= 0;
            data_reg <= 0;
            miso <= 0;
        end else begin
            case (state)
                IDLE: begin
                    cs <= 1; // Chip select inactive
                    if (start) begin
                        data_reg <= mosi; // Load data to send
                        cs <= 0; // Chip select active
                        state <= SEND;
                    end
                end
                SEND: begin
                    if (bit_cnt < 8) begin
                        miso <= data_reg[7 - bit_cnt]; // Send MSB first
                        state <= SCLK_LOW; // Move to clock generation
                    end else begin
                        state <= DONE; // Finished sending
                    end
                end
                SCLK_LOW: begin
                    sclk <= 0; // SCLK low
                    state <= SCLK_HIGH; // Move to SCLK high
                end
                SCLK_HIGH: begin
                    sclk <= 1; // SCLK high
                    bit_cnt <= bit_cnt + 1; // Increment bit counter
                    state <= SEND; // Go back to sending
                end
                DONE: begin
                    cs <= 1; // Chip select inactive
                    bit_cnt <= 0; // Reset bit counter
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule
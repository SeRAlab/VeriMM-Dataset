module uart_receiver (
    input wire clk,         // 50 MHz clock
    input wire rst,         // reset signal
    input wire rx,          // serial data input
    output reg [7:0] data,  // received data byte
    output reg data_ready   // signal indicating data is ready
);

    parameter CLOCK_FREQ = 50000000;  // clock frequency
    parameter BAUD_RATE = 9600;
    parameter BIT_PERIOD = CLOCK_FREQ / BAUD_RATE; // number of clock cycles per bit

    reg [3:0] bit_count;               // count the bits
    reg [15:0] clk_count;               // count the clock cycles
    reg state;                          // state of the receiver (idle or receiving)
    
    localparam IDLE = 1'b0;
    localparam RECEIVING = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            clk_count <= 0;
            bit_count <= 0;
            data <= 0;
            data_ready <= 0;
        end else begin
            case (state)
                IDLE: begin
                    data_ready <= 0;
                    if (rx == 0) begin  // Start bit detected
                        state <= RECEIVING;
                        clk_count <= 0;
                        bit_count <= 0;
                    end
                end
                RECEIVING: begin
                    if (clk_count < BIT_PERIOD - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        if (bit_count < 8) begin
                            data[bit_count] <= rx; // Sample the data bit
                            bit_count <= bit_count + 1;
                        end else begin
                            data_ready <= 1; // Data is ready
                            state <= IDLE;   // Go back to idle
                        end
                    end
                end
            endcase
        end
    end
endmodule
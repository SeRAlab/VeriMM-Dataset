module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire send,
    output reg tx,
    output reg busy
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // 50 MHz clock
    localparam BIT_TIME = CLOCK_FREQ / BAUD_RATE;
    
    reg [3:0] state;
    reg [7:0] shift_reg;
    reg [15:0] counter;
    
    localparam IDLE = 4'b0000;
    localparam START_BIT = 4'b0001;
    localparam DATA_BITS = 4'b0010;
    localparam STOP_BIT = 4'b0011;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1;
            busy <= 0;
            state <= IDLE;
            counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send && !busy) begin
                        busy <= 1;
                        shift_reg <= data_in;
                        counter <= 0;
                        tx <= 0; // Start bit
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    if (counter < BIT_TIME - 1) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        state <= DATA_BITS;
                    end
                end
                DATA_BITS: begin
                    if (counter < BIT_TIME - 1) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        tx <= shift_reg[0]; // Send LSB first
                        shift_reg <= {1'b0, shift_reg[7:1]}; // Shift right
                        if (shift_reg == 8'b00000000) begin
                            state <= STOP_BIT;
                        end
                    end
                end
                STOP_BIT: begin
                    if (counter < BIT_TIME - 1) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        tx <= 1; // Stop bit
                        busy <= 0;
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
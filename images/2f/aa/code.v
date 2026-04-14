module uart_tx #(
    parameter CLOCK_FREQ = 50000000, // 50 MHz
    parameter BAUD_RATE = 9600
) (
    input wire clk,
    input wire rst,
    input wire tx_en,
    input wire [7:0] data_in,
    output reg tx,
    output reg tx_done
);
    localparam BAUD_DIVISOR = CLOCK_FREQ / BAUD_RATE;
    localparam IDLE = 3'b000, START_BIT = 3'b001, DATA_BITS = 3'b010, STOP_BIT = 3'b011;
    
    reg [2:0] state;
    reg [3:0] bit_index;
    reg [15:0] baud_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1; // Idle state is high
            tx_done <= 0;
            baud_counter <= 0;
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1;
                    tx_done <= 0;
                    if (tx_en) begin
                        state <= START_BIT;
                        baud_counter <= 0;
                    end
                end
                
                START_BIT: begin
                    if (baud_counter < BAUD_DIVISOR - 1) begin
                        baud_counter <= baud_counter + 1;
                    end else begin
                        baud_counter <= 0;
                        tx <= 0; // Start bit
                        state <= DATA_BITS;
                        bit_index <= 0;
                    end
                end
                
                DATA_BITS: begin
                    if (baud_counter < BAUD_DIVISOR - 1) begin
                        baud_counter <= baud_counter + 1;
                    end else begin
                        baud_counter <= 0;
                        tx <= data_in[bit_index]; // Send data bits
                        if (bit_index == 7) begin
                            state <= STOP_BIT;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end
                end
                
                STOP_BIT: begin
                    if (baud_counter < BAUD_DIVISOR - 1) begin
                        baud_counter <= baud_counter + 1;
                    end else begin
                        baud_counter <= 0;
                        tx <= 1; // Stop bit
                        tx_done <= 1; // Indicate transmission is done
                        state <= IDLE; // Return to idle
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule
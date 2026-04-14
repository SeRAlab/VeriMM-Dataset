module uart_transmitter (
    input wire clk,             // Clock signal
    input wire tx_en,          // Transmit enable
    input wire [7:0] data_in,  // 8-bit data input
    output reg tx_out          // Serial data output
);
    parameter BAUD_RATE = 9600;
    parameter CLK_FREQ = 50000000; // Example: 50 MHz clock
    localparam BIT_TIME = CLK_FREQ / BAUD_RATE;
    
    reg [3:0] state;            // State of the transmitter
    reg [15:0] count;           // Bit time counter
    reg [3:0] bit_index;        // Current bit index

    localparam IDLE = 0;
    localparam START_BIT = 1;
    localparam DATA_BITS = 2;
    localparam STOP_BIT = 3;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx_out <= 1; // Idle state (high)
                if (tx_en) begin
                    state <= START_BIT;
                    count <= 0;
                    bit_index <= 0;
                end
            end
            
            START_BIT: begin
                if (count < BIT_TIME - 1) begin
                    count <= count + 1;
                end else begin
                    tx_out <= 0; // Start bit (low)
                    count <= 0;
                    state <= DATA_BITS;
                end
            end
            
            DATA_BITS: begin
                if (count < BIT_TIME - 1) begin
                    count <= count + 1;
                end else begin
                    tx_out <= data_in[bit_index]; // Transmit data bit
                    count <= 0;
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        state <= STOP_BIT;
                    end
                end
            end
            
            STOP_BIT: begin
                if (count < BIT_TIME - 1) begin
                    count <= count + 1;
                end else begin
                    tx_out <= 1; // Stop bit (high)
                    count <= 0;
                    state <= IDLE;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
endmodule
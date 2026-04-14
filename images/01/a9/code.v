module uart_controller (
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_ready
);
    // Transmitter state machine
    reg [3:0] tx_state;
    reg [3:0] tx_bit_count;
    
    // Receiver state machine
    reg [3:0] rx_state;
    reg [3:0] rx_bit_count;
    
    // States
    parameter IDLE = 0, START_BIT = 1, DATA_BITS = 2, STOP_BIT = 3;
    
    // Transmitter logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1;
            tx_state <= IDLE;
            tx_bit_count <= 0;
        end else begin
            case (tx_state)
                IDLE: if (tx_start) begin
                    tx <= 0; // Start bit
                    tx_state <= START_BIT;
                    tx_bit_count <= 0;
                end
                START_BIT: begin
                    if (tx_bit_count < 8) begin
                        tx <= tx_data[tx_bit_count]; // Transmit data bits
                        tx_bit_count <= tx_bit_count + 1;
                    end else begin
                        tx <= 1; // Stop bit
                        tx_state <= STOP_BIT;
                    end
                end
                STOP_BIT: begin
                    tx <= 1; // Stop bit
                    tx_state <= IDLE;
                end
            endcase
        end
    end
    
    // Receiver logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_state <= IDLE;
            rx_bit_count <= 0;
            rx_ready <= 0;
        end else begin
            case (rx_state)
                IDLE: if (~rx) begin // Detect start bit
                    rx_state <= START_BIT;
                    rx_bit_count <= 0;
                end
                START_BIT: begin
                    if (rx_bit_count < 8) begin
                        rx_data[rx_bit_count] <= rx; // Capture data bits
                        rx_bit_count <= rx_bit_count + 1;
                    end else begin
                        rx_ready <= 1; // Data ready
                        rx_state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
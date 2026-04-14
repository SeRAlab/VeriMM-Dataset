module uart_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] tx_data,
    input wire tx_start,
    output reg tx_done,
    output reg [7:0] tx_out,
    input wire rx_start,
    output reg [7:0] rx_data,
    output reg rx_done
);
    reg [3:0] state; // State variable
    reg [3:0] bit_count; // Bit counter for transmission and reception

    localparam IDLE = 4'b0000,
               TX_START = 4'b0001,
               TX_DATA = 4'b0010,
               TX_DONE = 4'b0011,
               RX_START = 4'b0100,
               RX_DATA = 4'b0101,
               RX_DONE = 4'b0110;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx_done <= 0;
            rx_done <= 0;
            bit_count <= 0;
            tx_out <= 0;
            rx_data <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_done <= 0;
                    rx_done <= 0;
                    if (tx_start) begin
                        tx_out <= tx_data; // Load data to transmit
                        state <= TX_START;
                        bit_count <= 0;
                    end else if (rx_start) begin
                        state <= RX_START;
                        bit_count <= 0;
                    end
                end
                TX_START: begin
                    // Simulate some time delay for start bit
                    state <= TX_DATA;
                end
                TX_DATA: begin
                    if (bit_count < 8) begin
                        // Transmit each bit
                        tx_out <= {tx_out[6:0], 1'b0}; // Shift transmit data
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= TX_DONE;
                    end
                end
                TX_DONE: begin
                    tx_done <= 1; // Indicate transmission is done
                    state <= IDLE; // Go back to idle
                end
                RX_START: begin
                    // Simulate some time delay for start bit
                    state <= RX_DATA;
                end
                RX_DATA: begin
                    if (bit_count < 8) begin
                        // Simulate receiving each bit
                        rx_data <= {1'b0, rx_data[7:1]}; // Shift received data
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= RX_DONE;
                    end
                end
                RX_DONE: begin
                    rx_done <= 1; // Indicate reception is done
                    state <= IDLE; // Go back to idle
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
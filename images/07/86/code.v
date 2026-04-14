module uart_controller (  
    input wire clk,  
    input wire reset,  
    input wire start_tx,  
    input wire [7:0] data_in,  
    input wire rx,  
    output reg tx,  
    output reg [7:0] data_out,  
    output reg data_ready  
);  
    parameter IDLE = 2'b00, TRANSMIT = 2'b01, RECEIVE = 2'b10;  
    reg [1:0] state;  
    reg [3:0] bit_index;  
    reg [7:0] tx_buffer;  
    reg [7:0] rx_buffer;  
    reg [3:0] rx_bit_index;  
    reg [7:0] rx_shift;  
    reg tx_busy;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            tx <= 1;  
            data_ready <= 0;  
            bit_index <= 0;  
            rx_bit_index <= 0;  
            rx_shift <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_tx && !tx_busy) begin  
                        tx_busy <= 1;  
                        tx_buffer <= data_in;  
                        bit_index <= 0;  
                        tx <= 0; // Start bit  
                        state <= TRANSMIT;  
                    end  
                end  
                TRANSMIT: begin  
                    if (bit_index < 8) begin  
                        tx <= tx_buffer[bit_index];  
                        bit_index <= bit_index + 1;  
                    end else if (bit_index == 8) begin  
                        tx <= 1; // Stop bit  
                        bit_index <= bit_index + 1;  
                    end else begin  
                        tx_busy <= 0;  
                        state <= IDLE;  
                        bit_index <= 0;  
                    end  
                end  
                RECEIVE: begin  
                    // Shift in the received data  
                    if (rx_bit_index < 8) begin  
                        rx_shift <= {rx, rx_shift[7:1]};  
                        rx_bit_index <= rx_bit_index + 1;  
                    end else begin  
                        data_out <= rx_shift[7:0];  
                        data_ready <= 1;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  

    always @(posedge clk) begin  
        if (rx == 0 && state == IDLE) begin  
            state <= RECEIVE;  
            rx_bit_index <= 0;  
            rx_shift <= 0;  
        end  
        if (data_ready) begin  
            data_ready <= 0;  
        end  
    end  
endmodule
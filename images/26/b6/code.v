module uart_transmitter #(parameter BAUD_RATE = 9600)(  
    input wire clk,  
    input wire reset,  
    input wire transmit_enable,  
    input wire [7:0] data_in,  
    output reg serial_out  
);  
    reg [3:0] state;  
    reg [3:0] bit_index;  
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit  

    localparam IDLE = 4'd0;  
    localparam START = 4'd1;  
    localparam DATA = 4'd2;  
    localparam STOP = 4'd3;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            bit_index <= 4'd0;  
            serial_out <= 1; // idle state for UART is high  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (transmit_enable) begin  
                        shift_reg <= {1'b1, data_in, 1'b0}; // prepare start, data, and stop bits  
                        state <= START;  
                        bit_index <= 4'd0;  
                    end  
                end  
                START: begin  
                    serial_out <= 1'b0; // send start bit  
                    state <= DATA;  
                end  
                DATA: begin  
                    serial_out <= shift_reg[bit_index];  
                    if (bit_index < 4'd8)  
                        bit_index <= bit_index + 1;  
                    else begin  
                        state <= STOP;  
                    end  
                end  
                STOP: begin  
                    serial_out <= 1'b1; // send stop bit  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
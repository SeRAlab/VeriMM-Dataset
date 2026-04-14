module uart_transmitter(  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [7:0] data_in,  
    output reg tx  
);  
    reg [3:0] state;  
    reg [3:0] bit_counter;  
    reg [9:0] shift_reg;  // 1 start bit + 8 data bits + 1 stop bit  

    parameter IDLE = 4'b0000, START = 4'b0001, DATA = 4'b0010, STOP = 4'b0011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            tx <= 1;  // Idle state is high  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (enable) begin  
                        shift_reg <= {1'b1, data_in, 1'b0};  // Stop bit + data + start bit  
                        bit_counter <= 0;  
                        state <= START;  
                    end  
                end  
                START: begin  
                    tx <= 0;  // Start bit  
                    state <= DATA;  
                end  
                DATA: begin  
                    tx <= shift_reg[bit_counter + 1];  // Transmit next data bit  
                    bit_counter <= bit_counter + 1;  
                    if (bit_counter == 8) begin  
                        state <= STOP;  
                    end  
                end  
                STOP: begin  
                    tx <= 1;  // Stop bit  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
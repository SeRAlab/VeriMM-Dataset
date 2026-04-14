module uart_transmitter (  
    input wire clk,  
    input wire enable,  
    input wire [7:0] data_in,  
    output reg tx,  
    output reg done  
);  
    reg [3:0] bit_index;  
    reg [10:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit  
    parameter IDLE = 1'b0, TRANSMIT = 1'b1;  
    reg state, next_state;  

    always @(posedge clk) begin  
        state <= next_state;  
    end  

    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (enable) begin  
                    shift_reg = {1'b1, data_in, 1'b0}; // Stop bit is '1', start bit is '0'  
                    bit_index = 0;  
                    next_state = TRANSMIT;  
                    done = 0;  
                end else begin  
                    next_state = IDLE;  
                    done = 1;  
                end  
            end  
            TRANSMIT: begin  
                if (bit_index < 11) begin  
                    tx = shift_reg[bit_index];  
                    bit_index = bit_index + 1;  
                    next_state = TRANSMIT;  
                    done = 0;  
                end else begin  
                    tx = 1; // Idle state  
                    next_state = IDLE;  
                    done = 1;  
                end  
            end  
        endcase  
    end  
endmodule
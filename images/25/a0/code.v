module uart_transmitter (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input send,  
    output reg tx,  
    output reg tx_complete  
);  
    reg [3:0] bit_index;  
    reg [1:0] state;  
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;  
    parameter BAUD_RATE_DIV = 16; // Adjust for your clock frequency  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1; // Idle state is high  
            tx_complete <= 0;  
            bit_index <= 0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    tx_complete <= 0;  
                    if (send) begin  
                        state <= START;  
                        tx <= 0; // Start bit  
                    end  
                end  
                START: begin  
                    state <= DATA;  
                    bit_index <= 0;  
                end  
                DATA: begin  
                    if (bit_index < 8) begin  
                        tx <= data_in[bit_index];  
                        bit_index <= bit_index + 1;  
                    end else begin  
                        state <= STOP;  
                    end  
                end  
                STOP: begin  
                    tx <= 1; // Stop bit  
                    tx_complete <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
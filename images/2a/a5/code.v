module uart_transmitter(  
    input wire clk,  
    input wire rst,  
    input wire valid,  
    input wire [7:0] data,  
    output reg tx  
);  
    reg [3:0] state;  
    reg [2:0] bit_idx;  
    reg [9:0] tx_shift;  
    parameter IDLE = 4'b0000,  
              START = 4'b0001,  
              DATA = 4'b0010,  
              STOP = 4'b0011;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            tx <= 1;  
            bit_idx <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (valid) begin  
                        tx_shift <= {1'b1, data, 1'b0}; // stop bit, data, start bit  
                        state <= START;  
                        bit_idx <= 0;  
                    end  
                end  
                START: begin  
                    tx <= 0; // Transmitting start bit  
                    state <= DATA;  
                end  
                DATA: begin  
                    tx <= tx_shift[bit_idx];  
                    if (bit_idx < 8)  
                        bit_idx <= bit_idx + 1;  
                    else  
                        state <= STOP;  
                end  
                STOP: begin  
                    tx <= 1; // Transmitting stop bit  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
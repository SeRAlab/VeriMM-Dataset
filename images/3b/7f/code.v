module uart_transmitter(  
    input clk,  
    input start,  
    input [7:0] data_in,  
    output reg tx,  
    output reg busy  
);  

    reg [3:0] state;  
    reg [3:0] bit_count;  

    parameter IDLE = 0, START_BIT = 1, DATA_BITS = 2, STOP_BIT = 3;  

    always @(posedge clk) begin  
        case(state)  
            IDLE: begin  
                tx <= 1;  
                busy <= 0;  
                if (start) begin  
                    state <= START_BIT;  
                    busy <= 1;  
                    bit_count <= 0;  
                end  
            end  
            START_BIT: begin  
                tx <= 0;  // Transmit start bit  
                state <= DATA_BITS;  
            end  
            DATA_BITS: begin  
                tx <= data_in[bit_count];  
                bit_count <= bit_count + 1;  
                if (bit_count == 7)  
                    state <= STOP_BIT;  
            end  
            STOP_BIT: begin  
                tx <= 1;  // Transmit stop bit  
                state <= IDLE;  
            end  
            default: state <= IDLE;  
        endcase  
    end  
endmodule
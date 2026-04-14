module uart_transmitter(  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input send,  
    output reg tx  
);  
    parameter BAUD_RATE = 9600;  
    parameter CLOCK_FREQ = 50000000;  
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;  
    reg [3:0] state;  
    reg [7:0] shift_reg;  
    reg [15:0] bit_count;  
    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;  
   
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            tx <= 1;  
            bit_count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (send) begin  
                        shift_reg <= data_in;  
                        tx <= 0; // Start bit  
                        bit_count <= 0;  
                        state <= START;  
                    end  
                end  
                START: begin  
                    if (bit_count < BIT_PERIOD - 1)  
                        bit_count <= bit_count + 1;  
                    else begin  
                        bit_count <= 0;  
                        state <= DATA;  
                    end  
                end  
                DATA: begin  
                    if (bit_count < BIT_PERIOD - 1)  
                        bit_count <= bit_count + 1;  
                    else begin  
                        if (shift_reg == 8'b0) begin  
                            tx <= 1; // Stop transmitting  
                            state <= IDLE;  
                        end else begin  
                            tx <= shift_reg[0];  
                            shift_reg <= {1'b0, shift_reg[7:1]};  
                            bit_count <= 0;  
                        end  
                    end  
                end  
            endcase  
        end  
    end  
endmodule
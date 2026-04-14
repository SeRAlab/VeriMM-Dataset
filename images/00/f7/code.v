module I2C_Controller(  
    input clk,  
    input start,  
    input stop,  
    input [7:0] data_in,  
    output reg sda,  
    output reg scl,  
    output reg ack  
);  
    reg [3:0] state;  
    reg [3:0] bit_count;  

    parameter IDLE = 4'b0000;  
    parameter START_COND = 4'b0001;  
    parameter DATA_TRANSFER = 4'b0010;  
    parameter STOP_COND = 4'b0011;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                sda <= 1;  
                scl <= 1;  
                ack <= 1;  
                if (start)  
                    state <= START_COND;  
            end  

            START_COND: begin  
                sda <= 0;  
                state <= DATA_TRANSFER;  
                bit_count <= 0;  
            end  

            DATA_TRANSFER: begin  
                if (bit_count < 8) begin  
                    sda <= data_in[7 - bit_count];  
                    scl <= 0;  
                    #1 scl <= 1;  
                    bit_count <= bit_count + 1;  
                end else begin  
                    state <= STOP_COND;  
                end  
            end  

            STOP_COND: begin  
                sda <= 0;  
                scl <= 1;  
                sda <= 1;  
                ack <= 1;  
                state <= IDLE;  
            end  

            default: state <= IDLE;  
        endcase  
    end  
endmodule
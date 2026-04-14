module i2c_master (  
    input clk,  
    input reset,  
    input start,  
    input [7:0] data_in,  
    output reg scl,  
    output reg sda,  
    output reg done  
);  
    reg [3:0] state;  
    parameter IDLE = 0, START = 1, WRITE = 2, STOP = 3;  
    reg [2:0] bit_cnt;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            scl <= 1;  
            sda <= 1;  
            done <= 0;  
            bit_cnt <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        sda <= 0;  // Start condition  
                        state <= START;  
                    end  
                end  
                START: begin  
                    scl <= 0;  
                    state <= WRITE;  
                    bit_cnt <= 0;  
                end  
                WRITE: begin  
                    sda <= data_in[7 - bit_cnt];  
                    scl <= 1;  
                    bit_cnt <= bit_cnt + 1;  
                    if (bit_cnt == 7) begin  
                        state <= STOP;  
                    end  
                end  
                STOP: begin  
                    scl <= 0;  
                    sda <= 1;  // Stop condition  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
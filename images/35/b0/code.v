module i2c_controller (  
    input clk,  
    input reset,  
    input start,  
    input stop,  
    input [7:0] write_data,  
    input read_enable,  
    output reg sda,  
    output reg scl,  
    output reg [7:0] read_data,  
    output reg busy,  
    output reg done  
);  
    reg [3:0] state;  
    reg [3:0] bit_count;  
    reg [7:0] send_buffer;  

    parameter IDLE = 4'b0000,  
              START = 4'b0001,  
              WRITE = 4'b0010,  
              READ = 4'b0011,  
              STOP = 4'b0100,  
              WAIT = 4'b0101;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            busy <= 0;  
            done <= 0;  
            sda <= 1;  
            scl <= 1;  
            bit_count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= START;  
                        busy <= 1;  
                        done <= 0;  
                    end  
                end  
                START: begin  
                    sda <= 0; // start condition  
                    state <= WRITE;  
                    bit_count <= 0;  
                    send_buffer <= write_data;  
                end  
                WRITE: begin  
                    if (bit_count < 8) begin  
                        scl <= 0;  
                        sda <= send_buffer[7 - bit_count];  
                        bit_count <= bit_count + 1;  
                        state <= WAIT;  
                    end else begin  
                        state <= STOP;  
                    end  
                end  
                WAIT: begin  
                    scl <= 1;  
                    state <= WRITE;  
                end  
                STOP: begin  
                    sda <= 0;  
                    scl <= 1;  
                    sda <= 1; // stop condition  
                    busy <= 0;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
module i2c_controller(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg sda,  
    output reg scl,  
    output reg done  
);  
    reg [3:0] state;  
    reg [3:0] bit_count;  
    
    parameter IDLE = 4'b0000,  
              START = 4'b0001,  
              SEND = 4'b0010,  
              STOP = 4'b0011;  
              
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            sda <= 1;  
            scl <= 1;  
            done <= 0;  
            bit_count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= START;  
                        done <= 0;  
                    end  
                end  
                START: begin  
                    sda <= 0;  
                    state <= SEND;  
                    bit_count <= 0;  
                end  
                SEND: begin  
                    scl <= 0;  
                    sda <= data_in[7 - bit_count];  
                    bit_count <= bit_count + 1;  
                    if (bit_count == 7) begin  
                        state <= STOP;  
                    end  
                end  
                STOP: begin  
                    scl <= 1;  
                    sda <= 1;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
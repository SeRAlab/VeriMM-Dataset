module i2c_master (  
    input clk,  
    input rst,  
    input start,  
    input [6:0] slave_addr,  
    input [7:0] data,  
    output reg sda,  
    output reg scl,  
    output reg done  
);  
    reg [3:0] state;  
    parameter IDLE = 4'd0, START = 4'd1, ADDRESS = 4'd2, WRITE = 4'd3, STOP = 4'd4;  
    reg [3:0] bit_cnt;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            sda <= 1;  
            scl <= 1;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    done <= 0;  
                    if (start) begin  
                        state <= START;  
                    end  
                end  
                START: begin  
                    sda <= 0;  
                    state <= ADDRESS;  
                    bit_cnt <= 7;  
                end  
                ADDRESS: begin  
                    sda <= slave_addr[bit_cnt];  
                    if (bit_cnt == 0) begin  
                        state <= WRITE;  
                    end else begin  
                        bit_cnt <= bit_cnt - 1;  
                    end  
                end  
                WRITE: begin  
                    sda <= data[bit_cnt];  
                    if (bit_cnt == 0) begin  
                        state <= STOP;  
                    end else begin  
                        bit_cnt <= bit_cnt - 1;  
                    end  
                end  
                STOP: begin  
                    sda <= 1;  
                    done <= 1;  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
            scl <= ~scl;  
        end  
    end  
endmodule
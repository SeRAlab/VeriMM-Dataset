module i2c_master_controller(  
    input clk,  
    input reset,  
    input start,  
    input [7:0] data_in,  
    output reg scl,  
    output reg sda,  
    output reg done  
);  
    reg [3:0] state;  
    reg [7:0] data;  
    parameter IDLE = 4'b0000, START = 4'b0001, SEND_DATA = 4'b0010, STOP = 4'b0011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            scl <= 1;  
            sda <= 1;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    done <= 0;  
                    if (start) begin  
                        state <= START;  
                        data <= data_in;  
                    end  
                end  
                START: begin  
                    scl <= 0;  
                    sda <= 0;  
                    state <= SEND_DATA;  
                end  
                SEND_DATA: begin  
                    scl <= 1;  
                    sda <= data[7];  
                    data <= {data[6:0], 1'b0};  
                    if (data == 8'b0) begin  
                        state <= STOP;  
                    end  
                end  
                STOP: begin  
                    sda <= 0;  
                    scl <= 0;  
                    sda <= 1;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
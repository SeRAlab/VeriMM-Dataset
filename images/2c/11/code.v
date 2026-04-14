module i2c_controller (  
    input wire SCL,  
    input wire SDA_in,  
    input wire start,  
    input wire stop,  
    output reg start_condition,  
    output reg stop_condition,  
    output reg [7:0] data_out  
);  
    reg [3:0] state;  
    reg [2:0] bit_count;  
    parameter IDLE = 0, START = 1, SEND = 2, STOP = 3;  
    
    always @(posedge SCL or posedge start or posedge stop) begin  
        if (start) begin  
            state <= START;  
            start_condition <= 1;  
            stop_condition <= 0;  
            bit_count <= 0;  
        end else if (stop) begin  
            state <= STOP;  
            stop_condition <= 1;  
            start_condition <= 0;  
        end else begin  
            start_condition <= 0;  
            stop_condition <= 0;  
            case (state)  
                IDLE: begin  
                    if (SDA_in == 1)  
                        state <= IDLE;  
                end  
                START: begin  
                    if (bit_count < 8) begin  
                        data_out[bit_count] <= SDA_in;  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        state <= IDLE;  
                    end  
                end  
                STOP: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
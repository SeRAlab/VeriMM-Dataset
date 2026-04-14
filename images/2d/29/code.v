module i2c_controller (  
    input clk,  
    input rst,  
    input start,  
    input write,  
    input [7:0] data_in,  
    output reg busy,  
    output reg [7:0] data_out,  
    output reg ack  
);  
    reg [2:0] state;  
    parameter IDLE = 3'b000,  
              START = 3'b001,  
              WRITE = 3'b010,  
              READ = 3'b011,  
              STOP = 3'b100;  
              
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            busy <= 0;  
            data_out <= 8'b0;  
            ack <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        busy <= 1;  
                        state <= (write) ? WRITE : READ;  
                    end  
                end  
                WRITE: begin  
                    data_out <= data_in;  
                    ack <= 1;  
                    state <= STOP;  
                end  
                READ: begin  
                    data_out <= 8'b10101010; // Simulated read data  
                    ack <= 1;  
                    state <= STOP;  
                end  
                STOP: begin  
                    busy <= 0;  
                    ack <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
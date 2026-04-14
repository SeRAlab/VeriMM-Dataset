module I2C_Controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] address,  
    input wire [7:0] data_in,  
    input wire rw, // 1 for read, 0 for write  
    output reg ack,  
    output reg [7:0] data_out,  
    output reg busy  
);  
  
    reg [2:0] state;  
    parameter IDLE = 3'b000, START = 3'b001, ADDR = 3'b010, DATA = 3'b011, STOP = 3'b100;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            ack <= 1'b0;  
            busy <= 1'b0;  
            data_out <= 8'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        busy <= 1'b1;  
                        ack <= 1'b0;  
                        state <= START;  
                    end  
                end  
                START: begin  
                    // Simulate start condition  
                    state <= ADDR;  
                end  
                ADDR: begin  
                    // Send address  
                    if (rw) begin  
                        // Read operation  
                        state <= DATA;  
                    end else begin  
                        // Write operation  
                        state <= DATA;  
                    end  
                end  
                DATA: begin  
                    if (rw) begin  
                        // Acknowledge and read data  
                        data_out <= data_in;  
                        ack <= 1'b1;  
                    end else begin  
                        // Acknowledge write operation  
                        ack <= 1'b1;  
                    end  
                    state <= STOP;  
                end  
                STOP: begin  
                    // Simulate stop condition  
                    busy <= 1'b0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
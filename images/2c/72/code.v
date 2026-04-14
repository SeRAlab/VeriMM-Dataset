module i2c_master(  
    input clk,  
    input rst,  
    input start,  
    input [7:0] data_in,  
    output reg sda,  
    output reg scl,  
    output reg ack  
);  
    reg [3:0] state;  
    reg [3:0] bit_count;  
    parameter IDLE = 4'b0000, START = 4'b0001, WRITE = 4'b0010, ACK = 4'b0011, STOP = 4'b0100;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            sda <= 1;  
            scl <= 1;  
            ack <= 0;  
            bit_count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        sda <= 0; // Start condition  
                        state <= START;  
                    end  
                end  
                START: begin  
                    scl <= 0;  
                    state <= WRITE;  
                    bit_count <= 0;  
                end  
                WRITE: begin  
                    sda <= data_in[7 - bit_count];  
                    scl <= 1;  
                    if (bit_count < 8) begin  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        state <= ACK;  
                    end  
                end  
                ACK: begin  
                    scl <= 0;  
                    ack <= !sda; // Simulate acknowledgment  
                    state <= STOP;  
                end  
                STOP: begin  
                    sda <= 1; // Stop condition  
                    scl <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
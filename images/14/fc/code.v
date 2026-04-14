module i2c_master(  
    input wire clk,  
    input wire enable,  
    input wire [7:0] data_in,  
    output reg scl,  
    output reg sda  
);  
    reg [2:0] state;  
    reg [3:0] bit_count;  
    parameter IDLE = 3'b000, START = 3'b001, SEND = 3'b010, ACK = 3'b011, STOP = 3'b100;  

    always @(posedge clk) begin  
        if (enable) begin  
            case (state)  
                IDLE: begin  
                    scl <= 1;  
                    sda <= 1;  
                    if (enable) begin  
                        state <= START;  
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
                    if (bit_count < 8) begin  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        state <= ACK;  
                    end  
                end  
                ACK: begin  
                    scl <= 1;  
                    // Here we would usually wait for an acknowledgment signal from the slave, but we will simulate it as always ACK  
                    state <= STOP;  
                end  
                STOP: begin  
                    sda <= 1;  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule
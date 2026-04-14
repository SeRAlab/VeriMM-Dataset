module i2c_controller (  
    input wire clk,  
    input wire enable,  
    input wire start,  
    input wire stop,  
    input wire [7:0] address,  
    input wire [7:0] data_in,  
    output reg ack,  
    output reg data_out,  
    output reg sda,  
    output reg scl  
);  
    reg [3:0] state;  
    parameter IDLE = 4'b0000, START = 4'b0001, WRITE = 4'b0010, READ = 4'b0011, STOP = 4'b0100;  
    reg [7:0] data_reg;  
    integer bit_count;  

    always @(posedge clk) begin  
        if (!enable) begin  
            state <= IDLE;  
            sda <= 1;  
            scl <= 0;  
            ack <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) state <= START;  
                end  
                START: begin  
                    sda <= 0;  
                    state <= WRITE;  
                    data_reg <= {address, data_in};  
                    bit_count <= 7;  
                end  
                WRITE: begin  
                    sda <= data_reg[bit_count];  
                    scl <= 1;  
                    bit_count <= bit_count - 1;  
                    if (bit_count < 0) begin  
                        state <= READ;  
                    end  
                end  
                READ: begin  
                    scl <= 0;  
                    data_out <= sda;  
                    ack <= 1;  
                    state <= STOP;  
                end  
                STOP: begin  
                    sda <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
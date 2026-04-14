module i2c_controller (  
    input wire clk,  
    input wire [7:0] data_byte,  
    input wire start,  
    input wire stop,  
    output reg SDA,  
    output reg SCL  
);  
    reg [3:0] state;  
    parameter IDLE = 0, START = 1, SEND = 2, STOP = 3;  
    reg [7:0] data;  
    integer bit_count;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                SDA <= 1;  
                SCL <= 1;  
                if (start) begin  
                    state <= START;  
                    data <= data_byte;  
                    bit_count <= 0;  
                end  
            end  
            START: begin  
                SDA <= 0;  
                SCL <= 1;  
                state <= SEND;  
            end  
            SEND: begin  
                SDA <= data[7 - bit_count];  
                SCL <= 0;  
                if (bit_count < 8) begin  
                    bit_count <= bit_count + 1;  
                end else begin  
                    state <= STOP;  
                end  
                SCL <= 1;  
            end  
            STOP: begin  
                SDA <= 0;  
                SCL <= 0;  
                SDA <= 1;  
                state <= IDLE;  
            end  
        endcase  
    end  
endmodule
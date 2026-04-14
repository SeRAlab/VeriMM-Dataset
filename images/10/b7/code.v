module i2c_controller(  
    input wire clk,  
    input wire start,  
    input wire [7:0] data,  
    output reg SDA,  
    output reg SCL  
);  
    reg [3:0] state;  
    parameter IDLE = 4'b0000, START = 4'b0001, SEND = 4'b0010, STOP = 4'b0011;  
    integer i;  
    always @(posedge clk) begin  
        case(state)  
            IDLE: begin  
                SDA <= 1;  
                SCL <= 1;  
                if (start) begin  
                    state <= START;  
                end  
            end  
            START: begin  
                SDA <= 0;  
                state <= SEND;  
                i <= 0;  
            end  
            SEND: begin  
                SCL <= 0;  
                SDA <= data[7-i];  
                i <= i + 1;  
                if (i == 7) begin  
                    state <= STOP;  
                end  
            end  
            STOP: begin  
                SCL <= 1;  
                SDA <= 1;  
                state <= IDLE;  
            end  
        endcase  
    end  
endmodule
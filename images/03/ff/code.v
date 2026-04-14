module point_doubling_fsm (  
    input clk,  
    input reset,  
    input [7:0] x,  
    input [7:0] y,  
    output reg [7:0] x_out,  
    output reg [7:0] y_out,  
    output reg done  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, PROCESS = 2'b01, OUTPUT = 2'b10;  
    reg [15:0] x_squared, y_squared;  
    parameter p = 8'd257;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            x_out <= 8'b0;  
            y_out <= 8'b0;  
            done <= 1'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    state <= PROCESS;  
                    done <= 1'b0;  
                end  
                PROCESS: begin  
                    x_squared <= (x * x) % p;  
                    y_squared <= (y * y) % p;  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    x_out <= x_squared[7:0];  
                    y_out <= y_squared[7:0];  
                    done <= 1'b1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
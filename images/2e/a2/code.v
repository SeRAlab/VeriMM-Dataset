module i2c_controller(  
    input clk,  
    input rst,  
    input start,  
    input [7:0] data_in,  
    output reg busy,  
    output reg sent  
);  

    reg [3:0] state;  
    reg [7:0] shift_reg;  
    parameter IDLE = 4'b0000, START = 4'b0001, SEND = 4'b0010, STOP = 4'b0011;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            busy <= 0;  
            sent <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    busy <= 0;  
                    sent <= 0;  
                    if (start) begin  
                        state <= START;  
                    end  
                end  
                START: begin  
                    busy <= 1;  
                    state <= SEND;  
                    shift_reg <= data_in;  
                end  
                SEND: begin  
                    if (shift_reg != 8'b0) begin  
                        // Simulate sending a bit (this would normally take clock cycles)  
                        shift_reg <= {shift_reg[6:0], 1'b0};  
                    end else begin  
                        state <= STOP;  
                    end  
                end  
                STOP: begin  
                    busy <= 0;  
                    sent <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
module robot_slam_fsm(  
    input clk,  
    input reset,  
    input [1:0] direction, // 00: UP, 01: DOWN, 10: LEFT, 11: RIGHT  
    output reg [7:0] x_pos,  
    output reg [7:0] y_pos  
);  
    initial begin  
        x_pos = 8'b00000000;  
        y_pos = 8'b00000000;  
    end  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x_pos <= 8'b00000000;  
            y_pos <= 8'b00000000;  
        end else begin  
            case (direction)  
                2'b00: y_pos <= y_pos + 1; // UP  
                2'b01: y_pos <= y_pos - 1; // DOWN  
                2'b10: x_pos <= x_pos - 1; // LEFT  
                2'b11: x_pos <= x_pos + 1; // RIGHT  
                default: begin  
                    x_pos <= x_pos;  
                    y_pos <= y_pos;  
                end  
            endcase  
        end  
    end  
endmodule
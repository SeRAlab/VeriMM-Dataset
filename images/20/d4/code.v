module SLAM (  
    input clk,  
    input reset,  
    input [1:0] command, // 00: up, 01: down, 10: left, 11: right  
    output reg [3:0] pos_x,  
    output reg [3:0] pos_y  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            pos_x <= 4'b0000;  
            pos_y <= 4'b0000;  
        end else begin  
            case (command)  
                2'b00: pos_y <= pos_y + 1; // move up  
                2'b01: pos_y <= pos_y - 1; // move down  
                2'b10: pos_x <= pos_x - 1; // move left  
                2'b11: pos_x <= pos_x + 1; // move right  
            endcase  
        end  
    end  
endmodule
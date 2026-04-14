module slam_fsm(  
    input clk,  
    input reset,  
    input [3:0] sensor_data, // Represents direction and distance  
    output reg [7:0] position_x,  
    output reg [7:0] position_y  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            position_x <= 8'b00000000;  
            position_y <= 8'b00000000;  
        end else begin  
            case (sensor_data)  
                4'b0001: position_y <= position_y + 1; // Move Up  
                4'b0010: position_y <= position_y - 1; // Move Down  
                4'b0100: position_x <= position_x + 1; // Move Right  
                4'b1000: position_x <= position_x - 1; // Move Left  
                default: begin  
                    position_x <= position_x;  
                    position_y <= position_y;  
                end  
            endcase  
        end  
    end  
endmodule
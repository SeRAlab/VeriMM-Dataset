module slam_system(  
    input clk,  
    input reset,  
    input [15:0] distance_measurement,  
    output reg [15:0] robot_position,  
    output reg [255:0] map_data  
);  
    reg [15:0] last_position;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            robot_position <= 16'h0000;  
            last_position <= 16'h0000;  
            map_data <= 256'h0;  
        end else begin  
            last_position <= robot_position;  
            robot_position <= last_position + distance_measurement;  
            map_data[robot_position] <= 1;  
        end  
    end  
endmodule
module slam_simulator (  
    input wire clk,  
    input wire rst,  
    input wire [4:0] position_update,  // 5-bit position update  
    input wire [4:0] map_update,       // 5-bit map update  
    output reg [9:0] estimated_position // 10-bit output for position (x,y)  
);  
    reg [4:0] x_position;  
    reg [4:0] y_position;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x_position <= 5'b00000;  
            y_position <= 5'b00000;  
        end else begin  
            x_position <= x_position + position_update;  
            y_position <= y_position + map_update;  
        end  
    end  

    always @(*) begin  
        estimated_position = {x_position, y_position};  
    end  
endmodule
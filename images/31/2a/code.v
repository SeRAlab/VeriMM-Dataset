module slam_robot (  
    input clk,  
    input reset,  
    input [15:0] x_in,  
    input [15:0] y_in,  
    input [15:0] vx_in,  
    input [15:0] vy_in,  
    output reg [15:0] x_out,  
    output reg [15:0] y_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x_out <= 16'b0;  
            y_out <= 16'b0;  
        end else begin  
            x_out <= x_in + vx_in;  
            y_out <= y_in + vy_in;  
        end  
    end  
endmodule
module slam_tracker (  
    input clk,  
    input reset,  
    input [7:0] sensor_data,  
    output reg [7:0] position  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        position <= 8'b0;  
    end else begin  
        position <= position + sensor_data;  
    end  
end  
endmodule
module TempSensorController(  
    input clk,  
    input rst,  
    input new_temp_valid,  
    input [7:0] new_temp,  
    input read_max,  
    output reg [7:0] max_temp  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            max_temp <= 8'b0;  
        end else if (new_temp_valid) begin  
            if (new_temp > max_temp) begin  
                max_temp <= new_temp;  
            end  
        end  
    end  
endmodule
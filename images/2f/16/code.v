module fan_speed_control(  
    input wire [1:0] speed_setting,  
    input wire enable,  
    output reg [1:0] fan_speed  
);  
    always @(posedge enable) begin  
        if (enable) begin  
            fan_speed <= speed_setting;  
        end else begin  
            fan_speed <= 2'b00;  
        end  
    end  
endmodule
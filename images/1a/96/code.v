module temp_sensor_controller (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] temperature,  
    output reg [2:0] status  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            status <= 3'b000;  
        end else begin  
            if (temperature < 4'd5) begin  
                status <= 3'b000; // Low  
            end else if (temperature >= 4'd5 && temperature <= 4'd10) begin  
                status <= 3'b001; // Normal  
            end else begin  
                status <= 3'b010; // High  
            end  
        end  
    end  
endmodule
module linear_voltage_regulator(  
    input [4:0] desired_voltage,  
    output reg [4:0] actual_voltage  
);  
    always @(*) begin  
        if (desired_voltage <= 5'b11111) begin  
            actual_voltage = desired_voltage;  
        end else begin  
            actual_voltage = 5'b11111;  
        end  
    end  
endmodule
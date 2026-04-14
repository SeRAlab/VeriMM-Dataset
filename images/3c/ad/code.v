module voltage_sensor (
    input [4:0] voltage_input,
    output reg voltage_exceeds
);
    
    always @(*) begin
        if (voltage_input > 5'd20) 
            voltage_exceeds = 1'b1;
        else 
            voltage_exceeds = 1'b0;
    end
endmodule
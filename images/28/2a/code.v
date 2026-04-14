module voltage_sensor(
    input [2:0] voltage,
    output reg signal
);
    always @(*) begin
        if (voltage > 3'b101) 
            signal = 1'b1;
        else 
            signal = 1'b0;
    end
endmodule
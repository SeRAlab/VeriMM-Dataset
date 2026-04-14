module voltage_regulator (
    input [4:0] voltage_in,
    output reg [4:0] voltage_out
);
    always @(*) begin
        if (voltage_in > 20) 
            voltage_out = 20;
        else 
            voltage_out = voltage_in;
    end
endmodule
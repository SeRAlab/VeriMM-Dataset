module linear_voltage_regulator (
    input [4:0] desired_voltage,
    output [4:0] regulated_voltage
);
    assign regulated_voltage = (desired_voltage > 31) ? 5'b11111 : desired_voltage;
endmodule
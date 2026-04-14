module voltage_regulator (
    input [4:0] desired_voltage,
    output [3:0] regulated_voltage
);
    assign regulated_voltage = (desired_voltage > 15) ? 4'b1111 : desired_voltage[3:0];
endmodule
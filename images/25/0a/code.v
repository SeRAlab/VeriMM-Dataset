module voltage_regulator (
    input [4:0] voltage_ref,
    output [4:0] regulated_voltage
);

assign regulated_voltage = (voltage_ref * 2 > 31) ? 31 : (voltage_ref * 2);

endmodule
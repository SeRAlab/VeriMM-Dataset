module voltage_regulator (
    input [4:0] vin,
    output [4:0] vout
);
    assign vout = (vin <= 5'd25) ? vin : 5'd25;
endmodule
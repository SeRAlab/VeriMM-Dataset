module voltage_regulator (
    input [4:0] vin,
    output [4:0] vout
);
    assign vout = (vin <= 5'b01111) ? vin : 5'b01111; // 15 in binary
endmodule
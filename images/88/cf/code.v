module top_module(
    input vin,
    input gnd,
    output tap
);wire vin_gnd;
    assign vin_gnd = vin - gnd;
    assign tap = vin_gnd ? vin : gnd;
endmodule
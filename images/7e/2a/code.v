module top_module(
   i,
   o,
   dynamicterminationcontrol,
   ibar
);parameter    bus_hold          = "false";
parameter    differential_mode = "false";
parameter    lpm_type          = "cyclonev_io_ibuf";

input        i;
output       o;
input        dynamicterminationcontrol;
input        ibar;

assign o = i;

endmodule
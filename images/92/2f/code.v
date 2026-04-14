module top_module(output o,
   (* iopad_external_pin *) input i,
   (* iopad_external_pin *) input ibar,
   input dynamicterminationcontrol);parameter differential_mode = "false";
   parameter bus_hold = "false";
   parameter simulate_z_as = "Z";
   parameter lpm_type = "cyclonev_io_ibuf";

   assign o    = i;
endmodule
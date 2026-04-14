module top_module(
    input tms, 
    input tck,
    input tdi, 
    input tdoutap,
    input tdouser,
    output tdo,
    output tmsutap,
    output tckutap,
    output tdiutap,
    output shiftuser,
    output clkdruser,
    output updateuser,
    output runidleuser,
    output usr1user
);parameter lpm_type = "cycloneive_jtag";

assign tdo = tdouser;

assign tmsutap = tms;

assign tckutap = tck;

assign tdiutap = tdi;

assign shiftuser = tdoutap;

assign clkdruser = tdoutap;

assign updateuser = tdoutap;

assign runidleuser = tdoutap;

assign usr1user = tdoutap;

endmodule
module top_module(
    input tms, 
    input tck,
    input tdi, 
    input ntrst,
    output tdo,
    output tmsutap,
    output tckutap,
    output tdiutap,
    output shiftuser,
    output clkdruser,
    output updateuser,
    output runidleuser,
    output usr1user
);parameter lpm_type = "arriaiigz_jtag";

reg tms_reg;
reg tck_reg;
reg tdi_reg;
reg shift_reg;
reg update_reg;
reg runidle_reg;
reg usr1_reg;
wire tdo_wire;
wire tmsutap_wire;
wire tckutap_wire;
wire tdiutap_wire;
wire shiftuser_wire;
wire clkdruser_wire;
wire updateuser_wire;
wire runidleuser_wire;
wire usr1user_wire;

assign tdo = tdo_wire;
assign tmsutap = tmsutap_wire;
assign tckutap = tckutap_wire;
assign tdiutap = tdiutap_wire;
assign shiftuser = shiftuser_wire;
assign clkdruser = clkdruser_wire;
assign updateuser = updateuser_wire;
assign runidleuser = runidleuser_wire;
assign usr1user = usr1user_wire;

always @(posedge tck) begin
    tms_reg <= tms;
    tck_reg <= tck;
    tdi_reg <= tdi;
    shift_reg <= shiftuser;
    update_reg <= updateuser;
    runidle_reg <= runidleuser;
    usr1_reg <= usr1user;
end

assign tdo_wire = (tck_reg & !ntrst & lpm_type == "arriaiigz_jtag") ? tdi_reg : 1'bZ;
assign tmsutap_wire = (tck_reg & !ntrst & lpm_type == "arriaiigz_jtag") ? tms_reg : 1'bZ;
assign tckutap_wire = (tck_reg & !ntrst & lpm_type == "arriaiigz_jtag") ? tck_reg : 1'bZ;
assign tdiutap_wire = (tck_reg & !ntrst & lpm_type == "arriaiigz_jtag") ? tdi_reg : 1'bZ;
assign shiftuser_wire = (tck_reg & !ntrst & lpm_type == "arriaiigz_jtag") ? shift_reg : 1'bZ;
assign clkdruser_wire = (tck_reg & !ntrst & lpm_type == "arriaiigz_jtag") ? tck_reg : 1'bZ;
assign updateuser_wire = (tck_reg & !ntrst & lpm_type == "arriaiigz_jtag") ? update_reg : 1'bZ;
assign runidleuser_wire = (tck_reg & !ntrst & lpm_type == "arriaiigz_jtag") ? runidle_reg : 1'bZ;
assign usr1user_wire = (tck_reg & !ntrst & lpm_type == "arriaiigz_jtag") ? usr1_reg : 1'bZ;

endmodule
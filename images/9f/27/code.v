module top_module(
    tms, 
    tck,
    tdi, 
    ntrst,
    tdoutap,
    tdouser,
    tdo,
    tmsutap,
    tckutap,
    tdiutap,
    shiftuser,
    clkdruser,
    updateuser,
    runidleuser,
    usr1user
);input tms;
input tck;
input tdi;
input ntrst;
input tdoutap;
input tdouser;

output tdo;
output tmsutap;
output tckutap;
output tdiutap;
output shiftuser;
output clkdruser;
output updateuser;
output runidleuser;
output usr1user;

parameter lpm_type = "cycloneii_jtag";

reg [1:0] state;
reg [31:0] shift_reg;
reg tdo_int; // Changed from wire to reg
reg tms_int; // Changed from wire to reg
reg tdi_int; // Changed from wire to reg
wire tck_int;

assign tdo = tdo_int;
assign tmsutap = tms_int;
assign tckutap = tck_int;
assign tdiutap = tdi_int;

assign shiftuser = state == 2'b00;
assign clkdruser = state == 2'b01;
assign updateuser = state == 2'b10;
assign runidleuser = state == 2'b11;
assign usr1user = 1'b0;

always @(posedge tck or posedge ntrst) begin
    if (ntrst) begin
        state <= 2'b11;
    end else begin
        case (state)
            2'b00: begin
                tms_int <= 1'b1;
                tdi_int <= 1'b0;
                if (tdouser) begin
                    shift_reg <= {shift_reg[30:0], tdoutap};
                end
                if (tms & !tck) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                tms_int <= 1'b0;
                tdi_int <= 1'b0;
                if (tck) begin
                    state <= 2'b00;
                end
            end
            2'b10: begin
                tms_int <= 1'b0;
                tdi_int <= 1'b1;
                if (tck) begin
                    state <= 2'b11;
                end
            end
            2'b11: begin
                tms_int <= 1'b1;
                tdi_int <= 1'b0;
                if (tck) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

assign tdo_int = (state == 2'b00) ? shift_reg[31] : 1'bZ;

endmodule
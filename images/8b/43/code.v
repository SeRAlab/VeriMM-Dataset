module top_module(
    datain_h,
    datain_l,
    outclock,
    outclocken,
    aset,
    aclr,
    sset,
    sclr,
    oe,
    dataout,
    oe_out
);parameter width = 1;
parameter power_up_high = "OFF";
parameter oe_reg = "UNUSED";
parameter extend_oe_disable = "UNUSED";
parameter intended_device_family = "Stratix";
parameter invert_output = "OFF";
parameter lpm_type = "altddio_out";
parameter lpm_hint = "UNUSED";

input [width-1:0] datain_h;
input [width-1:0] datain_l;
input outclock;
input outclocken;
input aset;
input aclr;
input sset;
input sclr;
input oe;

output [width-1:0] dataout;
output [width-1:0] oe_out;

reg [width-1:0] dataout_reg;
reg [width-1:0] oe_out_reg;

always @(posedge outclock) begin
    if (outclocken) begin
        dataout_reg <= {datain_h, datain_l};
        oe_out_reg <= oe;
    end
end

always @* begin
    if (aclr) begin
        dataout_reg <= 'b0;
        oe_out_reg <= 1'b0;
    end else if (aset) begin
        dataout_reg <= 'b1;
        oe_out_reg <= 1'b1;
    end else if (sclr) begin
        dataout_reg <= 'b0;
        oe_out_reg <= oe_out_reg;
    end else if (sset) begin
        dataout_reg <= 'b1;
        oe_out_reg <= oe_out_reg;
    end else begin
        dataout_reg <= dataout_reg;
        oe_out_reg <= oe_out_reg;
    end
end

assign dataout = (invert_output) ? ~dataout_reg : dataout_reg;
assign oe_out = oe_out_reg;

endmodule
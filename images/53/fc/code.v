module top_module(
                             i,
                             o,
                             obar
                             );parameter lpm_type = "arriaiigz_pseudo_diff_out";

input i;
output o;
output obar;

reg o_tmp;
reg obar_tmp;

assign o = o_tmp;
assign obar = obar_tmp;

always@(i)
    begin
        if( i == 1'b1)
            begin
                o_tmp = 1'b1;
                obar_tmp = 1'b0;
            end
        else if( i == 1'b0)
            begin
                o_tmp = 1'b0;
                obar_tmp = 1'b1;
            end
        else
            begin
                o_tmp = i;
                obar_tmp = i;
            end
    end
endmodule
module top_module(
                             i,
                             o,
                             obar,

				dtcin,
				dtc,
				dtcbar,
				oein,
				oeout,
				oebout
                             );parameter lpm_type = "cyclonev_pseudo_diff_out";

input i;
output o;
output obar;

   
input dtcin, oein;
output dtc, dtcbar, oeout, oebout;
   

reg o_tmp;
reg obar_tmp;
reg dtc_tmp, dtcbar_tmp, oeout_tmp, oebout_tmp;

assign dtc    = dtcin;
assign dtcbar = dtcin;
assign oeout  = oein;
assign oebout = oein;
   
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
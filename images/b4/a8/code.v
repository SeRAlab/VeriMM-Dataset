module top_module(output dout,
             input  din0, din1, din2, din3);/* Internal parameters which define the behaviour
   of the LUT primitive.
   lut_mask define the lut function, can be expressed in 16-digit bin or hex.
   sum_lutc_input define the type of LUT (combinational | arithmetic).
   dont_touch for retiming || carry options.
   lpm_type for WYSIWYG */

parameter lut_function = 16'hFFFF;
parameter dont_touch = "off";
parameter lpm_type = "fiftyfivenm_lcell_comb";
parameter sum_lutc_input = "datac";

reg [1:0] lut_type;
reg cout_rt;
reg combout_rt;
wire dataa_w;
wire datab_w;
wire datac_w;
wire datad_w;
wire cin_w;

assign dataa_w = din0;
assign datab_w = din1;
assign datac_w = din2;
assign datad_w = din3;

function lut_data;
input [15:0] mask;
input        dataa, datab, datac, datad;
reg [7:0]   s3;
reg [3:0]   s2;
reg [1:0]   s1;
  begin
       s3 = datad ? mask[15:8] : mask[7:0];
       s2 = datac ?   s3[7:4]  :   s3[3:0];
       s1 = datab ?   s2[3:2]  :   s2[1:0];
       lut_data = dataa ? s1[1] : s1[0];
  end

endfunction

initial begin
    /*if (sum_lutc_input == "datac")*/ lut_type = 0;
    /*else
    if (sum_lutc_input == "cin")   lut_type = 1;
    else begin
      $error("Error in sum_lutc_input. Parameter %s is not a valid value.\n", sum_lutc_input);
      $finish();
    end*/
end

always @(dataa_w or datab_w or datac_w or datad_w or cin_w) begin
    if (lut_type == 0) begin // logic function
        combout_rt = lut_data(lut_function, dataa_w, datab_w,
                            datac_w, datad_w);
    end
    else if (lut_type == 1) begin // arithmetic function
        combout_rt = lut_data(lut_function, dataa_w, datab_w,
                            cin_w, datad_w);
    end
    cout_rt = lut_data(lut_function, dataa_w, datab_w, cin_w, 'b0);
end

assign dout = combout_rt & 1'b1;
//assign cout = cout_rt & 1'b1;

endmodule
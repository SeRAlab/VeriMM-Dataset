module top_module(
                                 datain,
                                 rotate,
                                 shiftright,
                                 signa,
                                 signb,
                                 dataout
                                );parameter dataa_width = 32;
parameter datab_width = 32;
parameter operation_mode = "output_only";

input [71:0] datain;
input rotate;
input shiftright;
input signa;
input signb;

wire sign;
output [71:0] dataout;

reg[71:0] dataout_tmp;

specify
    (datain *> dataout)             = (0, 0);
    (rotate *> dataout)             = (0, 0);
    (shiftright*> dataout)          = (0, 0);
endspecify

assign sign = signa ^ signb;
assign dataout = dataout_tmp;
always@(datain or rotate or shiftright)
    begin
        dataout_tmp = datain;
        if((rotate == 0) && (shiftright == 0))
            dataout_tmp[39:8] = datain[39:8];
        else if((rotate == 0) && (shiftright == 1))
            dataout_tmp[39:8]= datain[71:40];
        else if ((rotate == 1) && (shiftright == 0))
            dataout_tmp[39:8] = datain[71:40] | datain[39:8]; 
        else
            dataout_tmp = datain;  
    end
endmodule
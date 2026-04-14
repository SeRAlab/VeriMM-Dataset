module top_module(
                                 input [71:0] datain,
                                 input rotate,
                                 input shiftright,
                                 input signa,
                                 input signb,
                                 output [71:0] dataout
                                );parameter dataa_width = 32;
parameter datab_width = 32;
parameter operation_mode = "output_only";

wire sign;
reg[71:0] dataout_tmp;

assign sign = signa ^ signb;

always@(datain or rotate or shiftright or signa or signb)
    begin
        dataout_tmp = datain;
        if((rotate == 0) && (shiftright == 0))
            dataout_tmp[39:8] = datain[39:8];
        else if((rotate == 0) && (shiftright == 1))
            dataout_tmp[39:8]= datain[71:40];
        else if ((rotate == 1) && (shiftright == 0))
            dataout_tmp[39:8] = datain[71:40] | datain[39:8]; 
    end
    
assign dataout = {sign, dataout_tmp[71:0]};

endmodule
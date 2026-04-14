module top_module(
                                 dataa,
                                 datab,
                                 sign,
                                 operation,
                                 dataout
                                );parameter    dataa_width = 36;
parameter    datab_width = 36;
parameter   fsa_mode = "add";


input [71  : 0 ] dataa;
input [71 : 0 ] datab;
input sign;
input [3:0] operation;


output [71: 0] dataout;


reg[71 :0] dataout_tmp;
reg[71:0] abs_b;
reg[71:0] abs_a;
reg sign_a;
reg sign_b;

specify
    (dataa *> dataout)              = (0, 0);
    (datab *> dataout)              = (0, 0);
    (sign *> dataout)               = (0, 0);
endspecify


assign dataout = dataout_tmp;

always @(dataa or datab or sign or operation)
    begin
        if((operation == 4'b0111) ||(operation == 4'b1000)|| (operation == 4'b1001))  
            begin
                dataout_tmp = {dataa[53:36],dataa[35:0],18'b0} + datab;
            end
    else
        begin
            sign_a  = (sign && dataa[dataa_width -1]);
            abs_a = (sign_a) ? (~dataa + 1'b1) : dataa;
            sign_b  = (sign && datab[datab_width-1]);
            abs_b = (sign_b) ? (~datab + 1'b1) : datab;
            if (fsa_mode == "add")
                dataout_tmp = (sign_a ? -abs_a : abs_a) + (sign_b ?-abs_b : abs_b);
            else
                dataout_tmp = (sign_a ? -abs_a : abs_a) - (sign_b ?-abs_b : abs_b);
        end
    end
endmodule
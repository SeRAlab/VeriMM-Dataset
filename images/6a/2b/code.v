module top_module(
                            dataa, 
                            datab, 
                            cin,
                            sumout,
                            cout 
                            );parameter dataa_width = 2;
    parameter datab_width = 2;
    parameter cin_inverted = "off";
    parameter lpm_type = "hardcopyiv_lcell_hsadder";


    parameter sumout_width = (dataa_width >= datab_width) ? (dataa_width + 1) : (datab_width + 1);


    
    input [dataa_width - 1 : 0] dataa;
    input [datab_width - 1 : 0] datab;
    input cin;
    
    
    output [sumout_width - 1 : 0] sumout;
    output cout;
    
    
    wire cin_sel;

    
    reg [sumout_width : 0] sumout_tmp;
    
    specify
    
        (dataa *> sumout) = (0, 0);
        (datab *> sumout) = (0, 0);
        (cin *> sumout) = (0, 0);
    
        (dataa *> cout) = (0, 0);
        (datab *> cout) = (0, 0);
        (cin *> cout) = (0, 0);
    
    endspecify

    assign cin_sel = (cin_inverted == "on") ? !cin : cin;

    always @(datab or dataa or cin_sel)
    begin
    
        sumout_tmp = dataa + datab + cin_sel;

    end
    
    assign sumout = sumout_tmp[sumout_width - 1 : 0];
    assign cout = sumout_tmp[sumout_width - 1];
endmodule
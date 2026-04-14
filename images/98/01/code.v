module top_module(
    input [3:0] in_vec,
    input sel_comp,
    output [3:0] outv,
    output [3:0] complement
);assign outv = in_vec;
    
    assign complement = (sel_comp == 1) ? ~in_vec + 1 : ~in_vec;
    
endmodule
module top_module(

    in_0,
    in_1,
    in_2,
    in_3,
    sel,
    out
    );input in_0, in_1, in_2, in_3;
    input [1:0] sel;
    output out;
    
    wire in_0_1, in_2_3;
    assign in_0_1 = sel[0] ? in_1 : in_0;
    assign in_2_3 = sel[0] ? in_3 : in_2;
    assign out = sel[1] ? in_2_3 : in_0_1;
    
endmodule
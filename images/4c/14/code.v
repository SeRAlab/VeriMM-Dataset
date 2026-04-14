module top_module(
    input [1:0] sel,
    input en,
    input in0,
    input in1,
    input in2,
    input in3,
    output out
);wire out_sel0;
    wire out_sel1;
    
    assign out_sel0 = (sel == 2'b00) ? in0 : in1;
    assign out_sel1 = (sel == 2'b10) ? in2 : in3;
    
    assign out = (en == 1'b1) ? ((sel == 2'b00 || sel == 2'b01) ? out_sel0 : out_sel1) : 1'b0;
    
endmodule
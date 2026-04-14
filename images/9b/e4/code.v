module top_module(
    input  in0,
    input  in1,
    input  in2,
    input  in3,
    input  sel0,
    input  sel1,
    output y
);wire m1, m2, m3;

    // Use a case statement for the 4-to-1 multiplexing logic
    assign y = (sel1 == 1'b0) ? 
                (sel0 == 1'b0 ? in0 : in1) : 
                (sel0 == 1'b0 ? in2 : in3);

endmodule
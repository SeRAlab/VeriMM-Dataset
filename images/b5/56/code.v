module top_module(
    input input1,
    input input2,
    input input3,
    input input4,
    input input5,
    input input6,
    input input7,
    input input8,
    output output1
);wire sum;
    assign sum = input1 + input2 + input3 + input4 + input5 + input6 + input7 + input8;
    
    assign output1 = (sum % 2 == 1) ? 1'b1 : 1'b0;

endmodule
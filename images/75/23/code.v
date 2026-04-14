module top_module(input[31:0] high_i, input[31:0]low_i, output[31:0] high_o, output[31:0] low_o);assign high_o[31:1] = high_i[30:0];
    assign high_o[0] = low_i[31];
    assign low_o[31:1] = low_i[30:0];
    assign low_o[0] = 1'b0;
    
endmodule
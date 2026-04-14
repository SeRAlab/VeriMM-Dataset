module top_module(input[15:0] extend,output[31:0] extended);assign extended[31:0] = { {16{extend[15]}} , extend[15:0] };
endmodule
module top_module(input INP, EN, VDD, VSS, output Z);wire [3:0] inp_buffered;
    assign inp_buffered = {INP, INP, INP, INP};

    assign Z = EN ? inp_buffered : 4'b0000;

endmodule
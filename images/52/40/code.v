module top_module(
    binaryInput,
    binaryOutput
);parameter N=3; 
    reg[N:0] binaryTwo= 2;

    
    input[N:0] binaryInput;
    output[N:0] binaryOutput;

    assign binaryOutput = binaryTwo*binaryInput;

endmodule
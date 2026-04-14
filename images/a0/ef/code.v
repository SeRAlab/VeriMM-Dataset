module parity_generator_4bit(
    input [3:0] data,
    output parity);
    
    assign parity = ^data; // XOR all bits to generate even parity
endmodule
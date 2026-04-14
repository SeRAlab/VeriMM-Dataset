module top_module(
    input  wire in1,
    input  wire in2,
    output wire out
);// Instantiate a generic AND gate module
    assign out = in1 & in2; // Replace with a simple continuous assignment

endmodule
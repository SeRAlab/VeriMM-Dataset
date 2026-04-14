module top_module(
    input A1,
    input A2,
    input VPWR,
    input VGND,
    output Y
);wire n1; // Declare internal wire for AND output

    // Implement AND functionality
    assign n1 = A1 & A2;

    // Use a behavioral model to output the result
    assign Y = n1;

endmodule
module top_module(output o, input i0, i1, i2, i3, i4, i5);wire w1; // Declare a wire for intermediate connection

    // Using basic AND and OR gates instead of ao222x1
    wire and_out1, and_out2;

    // Implementing AND operation for i0, i1 and i2, i3, i4, i5
    assign and_out1 = i0 & i1 & i2;
    assign and_out2 = i3 & i4 & i5;

    // Final OR operation for both AND outputs
    assign w1 = and_out1 | and_out2;

    // Output assignment
    assign o = w1;
endmodule
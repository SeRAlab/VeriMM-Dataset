module top_module(
    input A, B, S,
    output reg Y  // Change output to output reg
);always @ (A, B, S)
    begin
        if (S == 1'b1)
            Y = A;
        else
            Y = B;
    end

endmodule
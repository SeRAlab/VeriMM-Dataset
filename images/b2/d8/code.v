module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg out
);always @(*) begin
        if (|A > |B)  // check if magnitude of A is greater than magnitude of B
            out = 1;
        else
            out = 0;
    end

endmodule
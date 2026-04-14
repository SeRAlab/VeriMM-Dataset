module top_module(
    A,
    B,
    out
);input [15:0] A;
    input [15:0] B;
    output reg [31:0] out; // Changed to output reg to enable procedural assignment

    always @ (A, B) begin
        out <= A * B; // This is now valid since out is declared as a reg
    end

endmodule
module top_module(
    X,
    A
);// Module ports
    output reg [3:0] X;
    input [3:0] A;

    // Local signals
    wire [3:0] inv_A;
    wire [3:0] one = 4'b0001;

    // Invert all the bits of A
    assign inv_A = ~A;

    // Add 1 to the inverted number
    always @* begin
        X = inv_A + one;
    end

endmodule
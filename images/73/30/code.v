module Mux2to1 (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] y
);

    always @(*) begin
        if (sel)
            y <= b;
        else
            y <= a;
    end
endmodule
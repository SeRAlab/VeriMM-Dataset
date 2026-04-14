module mux_2to1 (
    input [4:0] a,
    input [4:0] b,
    input sel,
    output reg [4:0] y
);
    always @(*) begin
        if (sel)
            y = b;  // Forward input b
        else
            y = a;  // Forward input a
    end
endmodule
module mux2to1 (
    input [4:0] a,
    input [4:0] b,
    input sel,
    output reg [4:0] out
);
    always @(*) begin
        if (sel) begin
            out = b; // Forward b if sel is 1
        end else begin
            out = a; // Forward a if sel is 0
        end
    end
endmodule
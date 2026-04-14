module top_module(
    output reg [7:0] Y,
    output reg Sbar,
    output reg AeqB,
    output reg AneqB,
    input [7:0] A,
    input [7:0] B,
    input S,
    input VPWR,  // Changed to input
    input VGND,  // Changed to input
    input VPB,   // Changed to input
    input VNB    // Changed to input
);always @(*) begin
        if (S == 0) begin
            Y = A;
        end else begin
            Y = B;
        end
    end

    assign Sbar = ~S;
    assign AeqB = (A == B) ? 1 : 0;
    assign AneqB = (A != B) ? 1 : 0;

endmodule
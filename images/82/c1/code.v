module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    input SUB,
    input CLK,
    output reg [3:0] SUM,
    output reg BORROW
);always @(posedge CLK) begin
        if (SUB) begin
            SUM <= A - B - ~CIN;
            BORROW <= (A < B + ~CIN);
        end else begin
            SUM <= A + B + CIN;
            BORROW <= (SUM < A) | (SUM < B);
        end
    end

endmodule
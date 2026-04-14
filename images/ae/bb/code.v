module top_module(
    input [3:0] A,
    input [3:0] B,
    input CTRL,
    output reg [3:0] OUT,
    output reg OVF
);always @(*) begin
        if (CTRL == 0) begin
            OUT = A + B;
            OVF = (OUT[3] != A[3] && OUT[3] != B[3]) ? 1 : 0;
        end else begin
            OUT = A - B;
            OVF = (OUT[3] != A[3] && OUT[3] == B[3]) ? 1 : 0;
        end
    end

endmodule
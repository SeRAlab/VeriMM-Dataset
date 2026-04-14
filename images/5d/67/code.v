module top_module(
    input [7:0] A,
    input [7:0] B,
    input sub,
    output reg [7:0] out
);always @(*) begin
        if (sub == 1'b0) begin
            out = A + B;
        end else begin
            out = A - B;
        end
    end

endmodule
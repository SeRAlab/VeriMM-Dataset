module top_module(
    input [7:0] A,
    input [7:0] B,
    input SEL,
    output reg [7:0] OUT
);wire [7:0] negB;
    assign negB = (~B) + 1;

    always @(*) begin
        if (SEL == 0) begin
            OUT = A + B;
        end else begin
            OUT = A + negB;
        end
    end

endmodule
module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [8:0] C
);always @(*) begin
    C = A + B;
    if (C > 255) begin
        C = C + 1;
    end
end

endmodule
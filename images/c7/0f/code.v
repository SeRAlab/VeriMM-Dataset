module BOTTOM_MUX (
    input [4:0] a,
    input [4:0] b,
    input sel,
    output reg [4:0] y
);

always @(*) begin
    if (sel == 1) begin
        y = a;
    end else begin
        y = b;
    end
end

endmodule
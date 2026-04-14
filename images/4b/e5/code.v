module mux_2to1_4bit (
    input sel,
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] y
);

always @(*) begin
    if (sel) begin
        y = b;
    end else begin
        y = a;
    end
end

endmodule
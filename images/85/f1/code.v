module mux_2to1_4bit(
    input sel,
    input [3:0] in0,
    input [3:0] in1,
    output reg [3:0] out
);

always @(*) begin
    if (sel)
        out = in1;
    else
        out = in0;
end

endmodule
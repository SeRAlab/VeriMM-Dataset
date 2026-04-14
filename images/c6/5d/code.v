module output_select(
    input sel,
    input [7:0] out1,
    input [7:0] out2,
    output reg [7:0] out
);

always @(*) begin
    if(sel == 0)
        out = out1;
    else
        out = out2;
end

endmodule
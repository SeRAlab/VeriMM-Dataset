module mux2to1_4bit (
    input [3:0] data0,
    input [3:0] data1,
    input sel,
    output reg [3:0] out
);

always @(*) begin
    if (sel)
        out = data1;
    else
        out = data0;
end

endmodule
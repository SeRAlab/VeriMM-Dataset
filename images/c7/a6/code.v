module mux_8bit(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output reg [7:0] out
);

always @(*) begin
    if(sel == 0) begin
        out = a;
    end else begin
        out = b;
    end
end

endmodule
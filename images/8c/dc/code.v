module mux_2to1 (
    input wire sel,
    input wire in0,
    input wire in1,
    output reg out
    );

always @(*) begin
    if (sel)
        out = in1;
    else
        out = in0;
end

endmodule
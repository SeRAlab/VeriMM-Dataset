module mux_2to1 (
    input a,
    input b,
    input sel,
    output reg out
);

always @ (sel)
begin
    if (sel == 0)
        out = a;
    else
        out = b;
end

endmodule
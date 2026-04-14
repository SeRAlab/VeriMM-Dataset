module mux_2to1 (
    input sel,
    input in0,
    input in1,
    output reg out
);

always @ (sel or in0 or in1)
begin
    if (sel == 0)
        out = in0;
    else
        out = in1;
end

endmodule
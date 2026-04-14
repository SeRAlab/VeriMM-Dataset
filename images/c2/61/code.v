module hysteresis_comparator (
    input in,
    input Vth_r,
    input Vth_f,
    output reg out
);

reg state;

always @ (in or state) begin
    if (in > Vth_r)
        state <= 1;
    else if (in < Vth_f)
        state <= 0;
end

assign out = state;

endmodule
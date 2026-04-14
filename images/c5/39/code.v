module mux_4to1(
    input a,
    input b,
    input c,
    input d,
    input sel_1,
    input sel_0,
    output reg out_always
);

always @(*) begin
    if(sel_1 == 0 && sel_0 == 0) begin
        out_always = a;
    end
    else if(sel_1 == 0 && sel_0 == 1) begin
        out_always = b;
    end
    else if(sel_1 == 1 && sel_0 == 0) begin
        out_always = c;
    end
    else begin
        out_always = d;
    end
end

endmodule
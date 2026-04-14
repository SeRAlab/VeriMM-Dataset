module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output reg out_always   
);always @(*) begin
    if (sel_b1 == 0) begin
        out_always = a;
    end else if (sel_b1 == 1 && sel_b2 == 0) begin
        out_always = b;
    end else if (sel_b1 == 1 && sel_b2 == 1) begin
        out_always = a | b;
    end
end

endmodule
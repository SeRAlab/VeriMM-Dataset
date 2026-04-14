module top_module(
    x0,
    x1,
    s,
    y
);input x0;
input x1;
input s;
output y;
reg y;




always @(s, x0, x1) begin: MUX2_1_B_LOGIC
    if (s) begin
        y = x1;
    end
    else begin
        y = x0;
    end
end

endmodule
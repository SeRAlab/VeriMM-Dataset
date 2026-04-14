module top_module(
    x0,
    x1,
    x2,
    x3,
    s0,
    s1,
    y
);input x0;
input x1;
input x2;
input x3;
input s0;
input s1;
output y;
reg y;




always @(x0, s0, x3, x2, x1, s1) begin: MUX4_1_B_LOGIC
    if (((s0 == 0) && (s1 == 0))) begin
        y = x0;
    end
    else if (((s0 == 1) && (s1 == 0))) begin
        y = x1;
    end
    else if (((s0 == 0) && (s1 == 1))) begin
        y = x2;
    end
    else begin
        y = x3;
    end
end

endmodule
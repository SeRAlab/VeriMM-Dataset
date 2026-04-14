module top_module(
    x,
    s,
    y0,
    y1
);input x;
input s;
output y0;
reg y0;
output y1;
reg y1;




always @(s, x) begin: DEMUX1_2_B_LOGIC
    if ((s == 0)) begin
        y0 = x;
        y1 = 0;
    end
    else begin
        y0 = 0;
        y1 = x;
    end
end

endmodule
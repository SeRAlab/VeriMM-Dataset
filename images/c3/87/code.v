module v84f0a1_v9a2a06 (
    input i0,
    input i1,
    input i2,
    input i3,
    output reg [3:0] o
);

always @(*) begin
    if (i0 == 0 && i1 == 0 && i2 == 0 && i3 == 0) begin
        o = 4'b0000;
    end else if (i0 == 1 && i1 == 1 && i2 == 1 && i3 == 1) begin
        o = 4'b1111;
    end else if (i0 != i1 && i0 != i2 && i0 != i3 && i1 != i2 && i1 != i3 && i2 != i3) begin
        o = 4'b0001;
    end else if (i0 == i1 && i0 == i2 && i0 == i3 && i0 != 0 && i0 != 1) begin
        o = 4'b1110;
    end else begin
        o = 4'b1010;
    end
end

endmodule
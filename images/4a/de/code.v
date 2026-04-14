module top_module(
    input [3:0] A,
    input [1:0] B,
    input C,
    input D,
    input E,
    input F,
    input G,
    input H,
    output reg X
);always @* begin
    if (A >= 8) begin
        X = 1;
    end else if (A < 8 && B == 2) begin
        X = 0;
    end else if (A < 8 && B == 1) begin
        X = 1;
    end else if (C == 1 && D == 0) begin
        X = 1;
    end else if (C == 0 && D == 1) begin
        X = 0;
    end else if (E == 1 && F == 1) begin
        X = 1;
    end else if (G == 1 && H == 0) begin
        X = 0;
    end else if (G == 0 && H == 1) begin
        X = 1;
    end
end

endmodule
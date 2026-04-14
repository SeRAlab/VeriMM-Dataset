module top_module(
    input A,
    input TE,
    input VPWR,
    input VGND,
    output reg Z
);always @(*) begin
        if (A == 1 && TE == 0) begin
            Z = VPWR;
        end else if (A == 0 && TE == 1) begin
            Z = VGND;
        end else if (A == 1 && TE == 1) begin
            Z = 1;
        end else if (A == 0 && TE == 0) begin
            Z = 0;
        end
    end

endmodule
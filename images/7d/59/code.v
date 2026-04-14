module top_module(
    input clk,    // Clocks are used in sequential circuits
    input d,
    input aset,
    input areset,
    output reg q );reg j, k;

    always @ (posedge clk) begin
        if (aset) begin
            q <= 1;
        end else if (areset) begin
            q <= 0;
        end else begin
            j <= d;
            k <= ~d;
            q <= j ^ q & ~k;
        end
    end
endmodule
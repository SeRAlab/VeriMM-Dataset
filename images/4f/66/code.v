module top_module(
    input CLK,
    input EN,
    input TE,
    input D,
    output reg Q
);reg gated_clk;

always @ (posedge CLK) begin
    if (EN) begin
        gated_clk <= 1'b1;
    end else begin
        gated_clk <= 1'b0;
    end
end

always @ (posedge gated_clk) begin
    if (TE) begin
        Q <= D;
    end
end

endmodule
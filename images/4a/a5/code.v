module top_module(
    input [31:0] IN,
    input Clk,
    input Reset,
    input Load,
    output reg [31:0] OUT
);always @(posedge Clk, negedge Reset) begin
    if (Reset == 0) begin
        OUT <= 0;
    end else if (Load == 0 && Clk == 1'b0) begin
        OUT <= OUT;
    end else if (Load == 1 && Clk == 1'b0) begin
        OUT <= IN;
    end
end

endmodule
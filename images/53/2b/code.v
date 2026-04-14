module top_module(
    input CLK_IN,
    input RST,
    output reg CLK_OUT
);always @(posedge CLK_IN, posedge RST) begin
    if (RST) begin
        CLK_OUT <= 1'b0;
    end else begin
        CLK_OUT <= CLK_IN;
    end
end

endmodule
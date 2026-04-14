module binary_latch_with_reset(
    input CLK,
    input RST,
    input D,
    output reg Q
);

always @(posedge CLK) begin
    if (RST == 1) begin
        Q <= 0;
    end else begin
        Q <= D;
    end
end

endmodule
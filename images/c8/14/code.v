module flip_flop (
    input CLK,
    input D,
    input RST,
    input EN,
    output reg Q
);

always @(posedge CLK) begin
    if (RST) begin
        Q <= 1'b0;
    end else if (EN) begin
        Q <= D;
    end
end

endmodule
module d_ff_en(
    input D,
    input EN,
    input CLK,
    output reg Q
);

always @(posedge CLK) begin
    if (EN) begin
        Q <= D;
    end
end

endmodule
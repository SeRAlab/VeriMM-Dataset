module shift_register (
    input Clk,
    input Reset,
    input SI,
    output reg [3:0] Q
);

always @(posedge Clk) begin
    if (Reset)
        Q <= 4'b0000;
    else
        Q <= {Q[2:0], SI};
end

endmodule
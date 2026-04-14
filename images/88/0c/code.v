module register_8bit (
    input Clk,
    input Enable,
    input Reset,
    input [7:0] D,
    output reg [7:0] Q
);

always @(posedge Clk) begin
    if (Reset)
        Q <= 8'b00000000;
    else if (Enable)
        Q <= D;
end

endmodule
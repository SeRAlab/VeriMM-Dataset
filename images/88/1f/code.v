module up_down_counter (
    input Clk,
    input Reset,
    input UpDown,
    output reg [3:0] Q
);

always @(posedge Clk) begin
    if (Reset)
        Q <= 4'b0000;
    else if (UpDown)
        Q <= Q + 1;
    else
        Q <= Q - 1;
end

endmodule
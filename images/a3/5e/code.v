module shift_left_register(CLK, RST, EN, OUT);
input CLK, RST, EN;
output reg [3:0] OUT;

always @(posedge CLK) begin
    if (RST)
        OUT <= 4'b0000;
    else if (EN)
        OUT <= {OUT[2:0], 1'b0};
end

endmodule
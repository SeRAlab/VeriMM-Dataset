module shift_register (CLK, RST, DATA_IN, Q);
input CLK, RST, DATA_IN;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 4'b0000;
    else
        Q <= {Q[2:0], DATA_IN};
end

endmodule
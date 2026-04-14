module shift_register(CLK, RST, LOAD, D, Q);
input CLK, RST, LOAD;
input [3:0] D;
output [3:0] Q;
reg [3:0] Q;

always @(posedge CLK) begin
    if (RST)
        Q <= 4'b0000;
    else if (LOAD)
        Q <= D;
    else
        Q <= {Q[2:0], 1'b0};
end

endmodule
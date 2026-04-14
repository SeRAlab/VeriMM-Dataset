module johnson_counter(CLK, RST, Q);
input CLK, RST;
output [3:0] Q;
reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 4'b0000;
    else
        Q <= {Q[2:0], ~Q[3]};
end

endmodule
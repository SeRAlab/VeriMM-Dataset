module ring_counter(CLK, RST, Q);
input CLK, RST;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 4'b0001;
    else
        Q <= {Q[2:0], Q[3]};
end

endmodule
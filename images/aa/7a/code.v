module top_module(CLK, led);input CLK;
output [3:0] led;
reg [7:0] Q;

always @(negedge CLK)
    Q = Q + 8'd1;

assign led[3:0] = Q[7:4];

endmodule
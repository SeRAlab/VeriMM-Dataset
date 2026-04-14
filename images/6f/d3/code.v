module shift_register (CLK, SI, Q);
input CLK, SI;
output reg [3:0] Q;

always @(posedge CLK) begin
    Q <= {Q[2:0], SI};
end

endmodule
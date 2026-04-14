module shift_register_8bit (D, CLK, LOAD, SHIFT, Q);
input [7:0] D;
input CLK, LOAD, SHIFT;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (LOAD)
        Q <= D;
    else if (SHIFT)
        Q <= {Q[0], Q[7:1]};
    else
        Q <= {Q[6:0], Q[7]};
end

endmodule
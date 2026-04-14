module shift_register_16bit(D, CLK, LOAD, Q);
input [15:0] D;
input CLK, LOAD;
output reg Q;

reg [15:0] register;

always @(posedge CLK) begin
    if (LOAD)
        register <= D;
    else
        register <= {1'b0, register[15:1]};
    Q <= register[0];
end

endmodule
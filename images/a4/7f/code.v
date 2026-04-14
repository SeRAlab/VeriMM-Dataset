module shift_register_3bit(CLK, RESET, SIN, Q);
input CLK, RESET, SIN;
output [2:0] Q;
reg [2:0] Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET)
        Q <= 3'b000;
    else
        Q <= {Q[1:0], SIN};
end

endmodule
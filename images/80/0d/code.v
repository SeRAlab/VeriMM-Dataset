module shift_register_3bit (CLK, RESET, D, Q);
input CLK, RESET, D;
output reg [2:0] Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET)
        Q <= 3'b000;
    else
        Q <= {Q[1:0], D};
end

endmodule
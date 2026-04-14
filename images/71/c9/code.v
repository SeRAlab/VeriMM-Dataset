module shift_register (CLK, LOAD, D, Q);
input CLK, LOAD;
input [7:0] D;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (LOAD) 
        Q <= D;
    else 
        Q <= {Q[6:0], 1'b0};
end

endmodule
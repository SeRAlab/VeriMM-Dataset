module shift_register(CLK, RST, LOAD, D, Q);
input CLK, RST, LOAD;
input [3:0] D;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 4'b0000;
    else begin
        if (LOAD)
            Q <= D;
        else
            Q <= {1'b0, Q[3:1]};
    end
end

endmodule
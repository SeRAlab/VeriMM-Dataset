module shift_register (CLK, RST, D, Q);
input CLK, RST;
input [3:0] D;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 4'b0000;
    end else begin
        Q <= {1'b0, Q[3:1]};
    end
end

endmodule
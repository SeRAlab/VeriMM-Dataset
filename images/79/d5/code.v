module shift_reg (D, CLK, RST, LOAD, Q);
input [3:0] D;
input CLK, RST, LOAD;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 4'b0000;
    end else if (LOAD) begin
        Q <= D;
    end else begin
        Q <= {1'b0, Q[3:1]};
    end
end

endmodule
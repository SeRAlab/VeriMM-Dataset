module shift_reg_8bit (CLK, RST, SI, Q);
input CLK, RST, SI;
output reg [7:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 8'b00000000;
    end else begin
        Q <= {Q[6:0], SI};
    end
end

endmodule
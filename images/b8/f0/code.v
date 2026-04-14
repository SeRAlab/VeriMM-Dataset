module mod10_counter (CLK, RST, Q);
input CLK, RST;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 4'b0000;
    end else if (Q == 4'b1001) begin
        Q <= 4'b0000;
    end else begin
        Q <= Q + 1;
    end
end

endmodule
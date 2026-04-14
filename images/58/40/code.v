module sync_counter (CLK, RST, UP_DOWN, Q);
input CLK, RST, UP_DOWN;
output reg [2:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 3'b000;
    end
    else if (UP_DOWN) begin
        Q <= Q + 1;
    end
    else begin
        Q <= Q - 1;
    end
end

endmodule
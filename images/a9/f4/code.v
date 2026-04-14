module down_counter (CLK, RST, Q);
input CLK, RST;
output reg [3:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 4'b1111;
    end else begin
        Q <= Q - 1;
    end
end

endmodule
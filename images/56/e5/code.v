module binary_counter (CLK, RST, EN, Q);
input CLK, RST, EN;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 4'b0000;
    end else if (EN) begin
        Q <= Q + 1;
    end
end

endmodule
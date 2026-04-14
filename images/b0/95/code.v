module sync_counter (CLK, RST, EN, Q);
input CLK, RST, EN;
output reg [1:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 2'b00;
    end else if (EN) begin
        Q <= Q + 1;
    end
end

endmodule
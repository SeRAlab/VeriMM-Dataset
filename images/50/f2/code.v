module down_counter (CLK, RST, EN, Q);
input CLK, RST, EN;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 8'b11111111;
    end
    else if (EN) begin
        Q <= Q - 1;
    end
end

endmodule
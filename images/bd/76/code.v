module binary_counter (CLK, RST, EN, COUNT);
input CLK, RST, EN;
output reg [3:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        COUNT <= 4'b0000;
    end else if (EN) begin
        if (COUNT == 4'b1111) begin
            COUNT <= 4'b0000;
        end else begin
            COUNT <= COUNT + 1;
        end
    end
end

endmodule
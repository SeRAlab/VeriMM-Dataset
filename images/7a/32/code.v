module bidirectional_counter (CLK, RST, EN, DIR, Q);
input CLK, RST, EN, DIR;
output reg [15:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 16'b0;
    end
    else if (EN) begin
        if (DIR) begin
            Q <= Q + 1;
        end
        else begin
            Q <= Q - 1;
        end
    end
end

endmodule
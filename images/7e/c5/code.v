module binary_counter(CLK, RST, Q);
input CLK, RST;
output [3:0] Q;
reg [3:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 4'b0000;
    end else begin
        Q <= Q + 1;
    end
end

endmodule
module counter_4bit (CLK, RESET, Q);
input CLK, RESET;
output reg [3:0] Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET)
        Q <= 4'b0000;
    else
        Q <= Q + 1;
end

endmodule
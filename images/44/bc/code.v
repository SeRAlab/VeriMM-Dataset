module lfsr(CLK, RST, Q);
input CLK, RST;
output reg [15:0] Q;

wire feedback = Q[15] ^ Q[13] ^ Q[12] ^ Q[10];

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 16'hFFFF;  // Initialize LFSR with all 1s
    else begin
        Q <= {Q[14:0], feedback};
    end
end

endmodule
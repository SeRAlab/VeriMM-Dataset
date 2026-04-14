module lfsr_16bit(
   input                clk,
   input                rst_n,

   output reg [15:0]    Q
);
    wire feedback = Q[15] ^ Q[13] ^ Q[12] ^ Q[10];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 16'd1;
        else Q <= {Q[14:0], feedback};
    end
endmodule
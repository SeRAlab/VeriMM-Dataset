module PRBS_24(
   input                clk,
   input                rst_n,
 
   output reg [23:0]    Q  
);
    wire feedback = Q[23] ^ Q[22] ^ Q[21] ^ Q[16];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 24'h1;
        else Q <= {Q[22:0], feedback};
    end
endmodule
module LFSR_32(
   input                clk,
   input                rst_n,
 
   output reg [31:0]    Q  
);
    wire feedback = Q[31] ^ Q[21] ^ Q[1] ^ Q[0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 32'h1;
        else Q <= {Q[30:0], feedback};
    end
endmodule
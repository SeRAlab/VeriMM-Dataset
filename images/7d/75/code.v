module lfsr_8bit(
   input                clk,
   input                rst_n,

   output reg [7:0]     Q
);
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) Q <= 8'b00000001;
        else begin
            Q <= {Q[6:0], Q[7] ^ Q[5] ^ Q[4] ^ Q[3]};
        end
    end
endmodule
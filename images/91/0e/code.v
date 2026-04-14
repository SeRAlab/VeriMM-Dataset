module verified_LFSR_counter(
   input                clk ,
   input                rst_n,
 
   output reg [31:0]    Q  
);
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 32'h1;
        else begin
            Q <= {Q[30:0], Q[31] ^ Q[30] ^ Q[29] ^ Q[9]};
        end
    end
endmodule
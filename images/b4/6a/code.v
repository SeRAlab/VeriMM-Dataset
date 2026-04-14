module LFSR_16bit(
   input                clk ,
   input                rst_n,
 
   output reg [15:0]    lfsr_out  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) 
            lfsr_out <= 16'h1; // Non-zero seed value
        else begin
            lfsr_out <= {lfsr_out[14:0], lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10]};
        end
    end
endmodule
module lfsr_8bit(
    input clk, 
    input enable, 
    output reg [7:0] lfsr);

    always @(posedge clk) begin
        if (enable)
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
    end
endmodule
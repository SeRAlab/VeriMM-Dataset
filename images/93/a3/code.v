module lfsr5bit (
    input wire clk,
    input wire rst,
    output reg [4:0] lfsr_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr_out <= 5'b00001; // Initial value
        else begin
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]};
        end
    end

endmodule
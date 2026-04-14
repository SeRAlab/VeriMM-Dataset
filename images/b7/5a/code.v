module lfsr (
    input clk,
    input areset,
    output reg [4:0] lfsr_out);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            lfsr_out <= 5'b00001;
        end else begin
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]};
        end
    end
endmodule
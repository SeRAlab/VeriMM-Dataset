module lfsr(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [7:0] lfsr_out
);

wire feedback = lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[3];

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        lfsr_out <= 8'b00000001;
    end else if (en) begin
        lfsr_out <= {lfsr_out[6:0], feedback};
    end
end

endmodule
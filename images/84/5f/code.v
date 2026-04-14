module lfsr_8bit(
    input wire clk,
    input wire rst,
    output reg [7:0] lfsr_out
);

    wire feedback;

    assign feedback = lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[3];

    always @(posedge clk) begin
        if (rst) begin
            lfsr_out <= 8'b00000001; // Initialize to a non-zero value
        end else begin
            lfsr_out <= {lfsr_out[6:0], feedback};
        end
    end
endmodule
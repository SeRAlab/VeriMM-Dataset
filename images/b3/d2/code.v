module fibonacci_lfsr_6bit (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [5:0] lfsr_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 6'b1; // Non-zero initial value
        end else if (en) begin
            lfsr_out <= {lfsr_out[4:0], lfsr_out[5] ^ lfsr_out[3]};
        end
    end

endmodule
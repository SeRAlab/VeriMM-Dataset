module LFSR(
    input clk,
    input rst,
    input [2:0] taps,
    output reg [7:0] random_out
);
    reg [7:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= 8'b1; // Initialize to a non-zero value
        end else begin
            // Feedback logic based on the tap positions
            lfsr <= {lfsr[6:0], (lfsr[7] ^ lfsr[taps[2]] ^ lfsr[taps[1]] ^ lfsr[taps[0]])};
        end
    end

    always @(posedge clk) begin
        random_out <= lfsr;
    end
endmodule
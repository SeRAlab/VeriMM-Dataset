module CSPRNG (
    input clk,
    input rst,
    output reg random_bit
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= 5'b00001; // Initial state
        end else begin
            random_bit <= lfsr[0]; // Output the least significant bit
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]}; // Shift and feedback
        end
    end
endmodule
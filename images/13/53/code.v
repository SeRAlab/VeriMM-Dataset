module CSPRNG (
    input clk,
    input rst,
    output reg [4:0] random_number
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= 5'b00001; // Seed value (must not be zero)
        end else begin
            // Feedback polynomial: x^5 + x^3 + 1
            lfsr <= {lfsr[3], lfsr[2], lfsr[1], lfsr[0], lfsr[4] ^ lfsr[2]};
        end
    end

    always @(posedge clk) begin
        random_number <= lfsr;
    end
endmodule
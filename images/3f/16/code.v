module csprng (
    input wire clk,
    input wire rst,
    input wire [3:0] seed,
    output reg [3:0] random_number
);
    reg [3:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed;
        end else begin
            // Example polynomial x^4 + x^3 + 1
            lfsr[3] <= lfsr[2];
            lfsr[2] <= lfsr[1];
            lfsr[1] <= lfsr[0];
            lfsr[0] <= lfsr[3] ^ lfsr[2]; // Feedback
        end
    end

    always @(posedge clk) begin
        random_number <= lfsr; // Output the current LFSR state
    end
endmodule
module mersenne_twister (
    input clk,
    input reset,
    input [31:0] seed,
    output reg [31:0] random_number
);
    reg [31:0] MT [0:623]; // State vector
    reg [9:0] index;       // Index for generating random numbers
    reg [31:0] lower_mask = 32'h7fffffff; // Lower mask
    reg [31:0] upper_mask = 32'h80000000; // Upper mask
    reg [31:0] a = 32'h9908b0df; // Magic constant

    integer i;

    // Initialization
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MT[0] <= seed;
            for (i = 1; i < 624; i = i + 1) begin
                MT[i] <= (1812433253 * (MT[i-1] ^ (MT[i-1] >> 30)) + i);
            end
            index <= 0;
        end else begin
            if (index == 0) begin
                // Generate 624 new values
                for (i = 0; i < 624; i = i + 1) begin
                    MT[i] <= (MT[i] & upper_mask) | (MT[(i + 1) % 624] & lower_mask);
                    MT[i] <= MT[i] >> 1;
                    if (MT[(i + 1) % 624] & 32'h1) begin
                        MT[i] <= MT[i] ^ a;
                    end
                end
            end
            // Extract the next number
            random_number <= MT[index];
            index <= (index + 1) % 624;
        end
    end
endmodule
module monte_carlo_simulation (
    input wire clk,
    input wire [7:0] num_samples,
    output reg [15:0] average
);
    reg [7:0] random_number;
    reg [31:0] sum;
    reg [7:0] count;

    always @(posedge clk) begin
        if (count < num_samples) begin
            random_number <= $random; // Generate a pseudo-random number
            sum <= sum + random_number; // Accumulate the sum
            count <= count + 1; // Increment count
        end else begin
            average <= sum / num_samples; // Compute average
        end
    end
endmodule
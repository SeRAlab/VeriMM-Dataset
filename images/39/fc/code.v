module csprng (
    input wire clk,
    input wire reset,
    input wire [3:0] seed,
    output reg [7:0] random_number
);
    reg [3:0] lfsr;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed; // Initialize LFSR with seed
            random_number <= 8'b0; // Clear output
        end else begin
            // Shift and feedback logic for LFSR
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[1]}; // Example feedback function
            random_number <= {random_number[6:0], lfsr[0]}; // Update random number
        end
    end
endmodule
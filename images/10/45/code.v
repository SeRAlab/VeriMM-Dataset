module lfsr_32bit (
    input wire clk,
    input wire reset,
    output reg [31:0] lfsr_out
);
    // Define the feedback polynomial taps
    wire feedback = lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[16] ^ lfsr_out[15] ^ 
                    lfsr_out[12] ^ lfsr_out[10] ^ lfsr_out[9] ^ lfsr_out[6] ^ 
                    lfsr_out[4] ^ lfsr_out[3] ^ lfsr_out[2] ^ lfsr_out[1];
    
    // Initial seed value
    parameter SEED = 32'hACE1; // Example seed

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= SEED;
        end else begin
            lfsr_out <= {lfsr_out[30:0], feedback};
        end
    end
endmodule
module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] in,   // 8-bit input for the parity generator
    output [7:0] out  // 8-bit output from the system
);// Parity generator
    wire [7:0] in_xor = ^in;
    wire parity_bit = in_xor[0] ^ in_xor[1] ^ in_xor[2] ^ in_xor[3] ^ in_xor[4] ^ in_xor[5] ^ in_xor[6] ^ in_xor[7];
    
    // Asynchronous reset 4-bit binary counter
    reg [3:0] counter = 4'b1000;
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            counter <= 4'b1000;
        end else if (counter == 4'b1111) begin
            counter <= 4'b0000;
        end else begin
            counter <= counter + 1;
        end
    end
    
    // Functional module to add parity bit and counter output
    wire [3:0] counter_plus_parity = counter + parity_bit;
    
    // Output
    assign out = {counter_plus_parity, counter};

endmodule
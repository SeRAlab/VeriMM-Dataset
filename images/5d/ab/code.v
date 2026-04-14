module top_module(
    input clk,
    input [7:0] I,
    output reg [2:0] O
);reg [7:0] I_reg; // Changed from array to single register
// Removed O_reg since it is unnecessary

always @ (posedge clk) begin
    I_reg <= I; // Store input I in I_reg temporarily

    // Priority encoding logic
    if (I_reg[7]) O <= 3'b111;  // 3 for output
    else if (I_reg[6]) O <= 3'b110; // 2 for output
    else if (I_reg[5]) O <= 3'b101; // 1 for output
    else if (I_reg[4]) O <= 3'b100; // 0 for output
    else if (I_reg[3]) O <= 3'b011; // 3 for output
    else if (I_reg[2]) O <= 3'b010; // 2 for output
    else if (I_reg[1]) O <= 3'b001; // 1 for output
    else if (I_reg[0]) O <= 3'b000; // 0 for output
    else O <= 3'b000; // Default case
end

endmodule
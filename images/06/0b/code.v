module power_gating (
    input wire power_on,
    input wire [3:0] block_input,
    output reg [3:0] block_output
);

always @(*) begin
    if (power_on) 
        block_output = block_input;
    else 
        block_output = 4'b0000; // Known state when powered off
end

endmodule
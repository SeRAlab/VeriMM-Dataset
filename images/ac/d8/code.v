module top_module( 
    input wire clk,          // Add clk as an input
    input wire [7:0] in_hi,
    input wire [7:0] in_lo,
    output wire [15:0] out );// Pipeline registers
    reg [15:0] stage1_out;   // Change to 16 bits to hold concatenated value
    reg [15:0] stage2_out;

    // Stage 1: Concatenate the two input bytes
    always @(*) begin
        stage1_out = {in_hi, in_lo};
    end

    // Stage 2: Pass the concatenated half-word to the output
    always @(posedge clk) begin
        stage2_out <= stage1_out;
    end

    assign out = stage2_out;

endmodule
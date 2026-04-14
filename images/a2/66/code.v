module top_module(
    input [254:0] in,
    input clk,            // Added the clk input
    output [7:0] out
);reg [7:0] count_reg;
reg [7:0] count_pipeline [31:0];

integer i;

// Pipeline registers
reg [254:0] shift_reg [31:0];
reg [254:0] shift_pipeline [31:0];

// Shift register
always @(*) begin
    shift_reg[0] = in;
    for (i = 1; i < 32; i = i + 1) begin
        shift_reg[i] = shift_pipeline[i-1];
    end
end

// Pipeline stages
always @(posedge clk) begin
    // Shift pipeline
    shift_pipeline[0] <= shift_reg[0];
    for (i = 1; i < 32; i = i + 1) begin
        shift_pipeline[i] <= shift_pipeline[i-1];
    end
    
    // Count pipeline
    count_pipeline[0] <= count_reg;
    for (i = 1; i < 32; i = i + 1) begin
        count_pipeline[i] <= count_pipeline[i-1];
    end
end

// Counting logic
always @(posedge clk) begin
    count_reg <= count_pipeline[31];
    if (shift_pipeline[31][0] == 1'b1) begin
        count_reg <= count_reg + 1;
    end
end

assign out = count_reg;

endmodule
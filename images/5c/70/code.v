module top_module(
    input [7:0] DATA,
    input [2:0] SHIFT_AMOUNT,
    input SHIFT_DIRECTION,
    output [7:0] SHIFTED_DATA
);reg [7:0] pipeline_reg [2:0];

// Pipeline stage 1
always @(*) begin
    if (SHIFT_DIRECTION == 1'b0) // Left shift
        pipeline_reg[0] = DATA << SHIFT_AMOUNT;
    else // Right shift
        pipeline_reg[0] = DATA >> SHIFT_AMOUNT;
end

// Pipeline stage 2
always @(*) begin
    pipeline_reg[1] = pipeline_reg[0];
end

// Pipeline stage 3
always @(*) begin
    pipeline_reg[2] = pipeline_reg[1];
end

assign SHIFTED_DATA = pipeline_reg[2];

endmodule
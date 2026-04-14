module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input clk, // Added clk input
    output reg EQ, // Changed to reg to allow assignment in always block
    output reg GT  // Changed to reg to allow assignment in always block
);reg [3:0] in0_reg;
reg [3:0] in1_reg;
reg [1:0] stage;

// Always block to determine EQ and GT outputs
always @(*) begin
    EQ = (in0_reg == in1_reg) ? 1'b1 : 1'b0;
    GT = (in0_reg > in1_reg) ? 1'b1 : 1'b0;
end

always @(*) begin
    case(stage)
        2'b00: begin
            in0_reg = in0;
            in1_reg = in1;
        end
        2'b01: begin
            in0_reg = in0_reg;
            in1_reg = in1_reg;
        end
        2'b10: begin
            in0_reg = in0_reg;
            in1_reg = in1_reg;
        end
        2'b11: begin
            in0_reg = in0_reg;
            in1_reg = in1_reg;
        end
    endcase
end

// Added clocked process for stage
always @(posedge clk) begin
    if (stage == 2'b11)
        stage <= 2'b00;
    else
        stage <= stage + 1;
end

endmodule
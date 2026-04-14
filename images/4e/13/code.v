module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [3:0] A, // 4-bit input A for the adder-subtractor
    input [3:0] B, // 4-bit input B for the adder-subtractor
    input SUB, // 1-bit input SUB for the adder-subtractor
    input [2:0] shift_in, // 3-bit input for the shift register
    input load, // Load input for the shift register
    output [2:0] shift_out, // 3-bit output from the shift register
    output [3:0] SUM // 4-bit output from the adder-subtractor
);reg [3:0] A_reg, B_reg, SUM_reg;
reg SUB_reg;
wire [3:0] A_B;
wire [3:0] A_minus_B;
wire [3:0] shifted_out;
reg [2:0] shift_reg;

// Adder-Subtractor
assign A_B = A + B;
assign A_minus_B = A - B;
always @ (posedge clk) begin
    if (reset) begin
        A_reg <= 4'b0;
        B_reg <= 4'b0;
        SUM_reg <= 4'b0;
        SUB_reg <= 1'b0;
    end else begin
        A_reg <= A;
        B_reg <= B;
        SUB_reg <= SUB;
        if (SUB_reg) begin
            SUM_reg <= A_minus_B;
        end else begin
            SUM_reg <= A_B;
        end
    end
end
assign SUM = SUM_reg;

// Shift Register
always @ (posedge clk) begin
    if (reset) begin
        shift_reg <= 3'b0;
    end else begin
        if (load) begin
            shift_reg <= shift_in;
        end else begin
            shift_reg <= {shift_reg[1:0], 1'b0};
        end
    end
end
assign shift_out = shift_reg;

// Additional Functional Module
assign shifted_out = {shift_reg[1:0], 1'b0};
assign SUM_shifted_OR = SUM_reg | shifted_out;

endmodule
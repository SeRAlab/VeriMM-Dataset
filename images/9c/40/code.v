module top_module(
    input [1:0] A,
    input [1:0] B,
    input clk,      // Added clk as an input
    output reg eq   // Changed output to reg type for assigning in always block
);reg [1:0] A_reg, B_reg;

always @ (posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

always @ (posedge clk) begin
    if (A_reg == B_reg) begin
        eq <= 1'b1;  // Changed to direct assignment to eq
    end else begin
        eq <= 1'b0;  // Changed to direct assignment to eq
    end
end

endmodule
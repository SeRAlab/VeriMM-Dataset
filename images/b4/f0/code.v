module top_module(
    input [3:0] in,
    input clk,          // Adding clk input to resolve binding errors
    output reg [4:0] out
);reg [3:0] in_reg;
reg [4:0] out_reg;
reg [4:0] neg_in_reg; // Change to reg [4:0] to hold the negated value correctly
reg [4:0] neg_out_reg;

always @ (posedge clk) begin
    in_reg <= in;
    neg_in_reg <= {1'b1, ~in_reg} + 1; // Corrected the width of neg_in_reg
end

always @ (posedge clk) begin
    if (in_reg[3] == 1) begin
        out_reg <= {1'b1, ~in_reg} + 1; // Corrected the width of out_reg
    end else begin
        out_reg <= {1'b0, in_reg};
    end
end

always @ (posedge clk) begin
    if (neg_in_reg[4] == 1) begin
        neg_out_reg <= {1'b1, ~neg_in_reg[3:0]} + 1; // Properly reference the lower bits
    end else begin
        neg_out_reg <= {1'b0, neg_in_reg[3:0]};
    end
end

assign out = (in_reg[3] == 1) ? neg_out_reg : out_reg;

endmodule
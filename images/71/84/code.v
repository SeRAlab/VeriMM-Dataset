module top_module(
    input clk,
    input [7:0] in,
    input d,
    output reg [1:0] pos
);reg [2:0] shift_reg;
reg [2:0] pattern = 3'b101;
wire [2:0] pattern_match;
wire [2:0] pattern_match_delayed;
wire [2:0] priority_enc;

assign pattern_match = (shift_reg == pattern);
assign pattern_match_delayed = {shift_reg[1:0], d};
assign priority_enc = |pattern_match_delayed;

always @(posedge clk) begin
    shift_reg <= {shift_reg[1:0], in[0]};
    pos <= 2'b00;
    if (priority_enc[2]) begin
        pos <= 2'b10;
    end else if (priority_enc[1]) begin
        pos <= 2'b01;
    end else if (priority_enc[0]) begin
        pos <= 2'b00;
    end
end

endmodule
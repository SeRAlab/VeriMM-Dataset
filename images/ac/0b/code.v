module johnson_counter (
    input clk,
    input reset,
    output [4:0] q );reg [4:0] count_reg;

always @(posedge clk) begin
    if (reset)
        count_reg <= 5'b00000;
    else
        count_reg <= {count_reg[3:0], ~count_reg[4]};
end

assign q = count_reg;

endmodule
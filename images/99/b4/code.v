module top_module(
    input clk,
    input [254:0] in,
    output reg [7:0] out
);reg [2:0] shift_reg;
reg [7:0] pop_count;
reg [254:0] in_reg; // Register to store the shifted value of in

always @(posedge clk) begin
    shift_reg <= {shift_reg[1:0], in_reg[0]};
    in_reg <= {in_reg[253:0], 1'b0}; // Shift in a '0' at the end of the input vector
end

always @(posedge clk) begin
    if (shift_reg == 3'b111) begin
        pop_count <= pop_count + 1;
    end
end

assign out = pop_count;

endmodule
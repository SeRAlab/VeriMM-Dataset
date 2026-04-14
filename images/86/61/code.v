module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q,
    output reg out_if_else
);reg [99:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
    end else if (ena != 2'b00) begin
        case (ena)
            2'b01: shift_reg <= {shift_reg[98:0], shift_reg[99]}; // Shift right by 1
            2'b10: shift_reg <= {shift_reg[97:0], shift_reg[99:98]}; // Shift right by 2
            // Add more cases as needed for different values of `ena`
            default: shift_reg <= shift_reg; // No change
        endcase
    end
end

always @* begin
    out_if_else = |(shift_reg ^ data); // This gives 1 if any bit differs
end

assign q = shift_reg;

endmodule
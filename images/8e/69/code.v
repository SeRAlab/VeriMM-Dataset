module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);reg [99:0] shift_reg;
reg [1:0] mode;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
        mode <= ena;
    end else begin
        case (mode)
            2'b00: shift_reg <= shift_reg; // No rotation
            2'b01: shift_reg <= {shift_reg[98:0], shift_reg[99]}; // Rotate right
            2'b10: shift_reg <= {shift_reg[0], shift_reg[99:1]}; // Rotate left
            2'b11: shift_reg <= {shift_reg[97:0], shift_reg[99:98]}; // Rotate right by 2
        endcase
    end
end

always @(posedge clk) begin
    q <= shift_reg; // Update output q on clock edge
end

endmodule
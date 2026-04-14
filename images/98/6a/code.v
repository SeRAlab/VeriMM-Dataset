module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    input wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0,
    output reg [99:0] q
);// Rotator module
reg [99:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
    end else begin
        case (ena)
            2'b01: shift_reg <= {shift_reg[0], shift_reg[99:1]};
            2'b10: shift_reg <= {shift_reg[98:0], shift_reg[99]};
            default: shift_reg <= shift_reg;
        endcase
    end
end

// Splitter module
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];
assign outv = vec;

// AND module
assign q = shift_reg & {o2, o1, o0};

endmodule
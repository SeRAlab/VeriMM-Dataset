module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q,
    output reg [99:0] q_out);reg [99:0] shift_reg;
    reg [4:0] shift_amt;

    always @ (posedge clk) begin
        if (load) begin
            shift_reg <= data;
            shift_amt <= 0;
        end else if (ena == 2'b01) begin
            shift_reg <= {shift_reg[0], shift_reg[99:1]};
            shift_amt <= shift_amt + 1;
        end else if (ena == 2'b10) begin
            shift_reg <= {shift_reg[99], shift_reg[98:0]};
            shift_amt <= shift_amt - 1;
        end
    end

    assign q = shift_reg;
    assign q_out = (ena == 2'b01) ? {shift_reg[0], shift_reg[99:1]} :
                   (ena == 2'b10) ? {shift_reg[99], shift_reg[98:0]} :
                   shift_reg;

endmodule
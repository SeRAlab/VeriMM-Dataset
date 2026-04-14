module top_module(
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output [7:0] C,
    output valid,
    input ready
);reg [7:0] result;
reg valid_reg;

always @(posedge clk) begin
    if (reset) begin
        result <= 8'd0;
        valid_reg <= 1'b0;
    end else if (ready) begin
        case (op)
            2'b00: result <= A + B;
            2'b01: result <= A - B;
            2'b10: result <= A * B;
            2'b11: result <= A / B;
        endcase
        valid_reg <= 1'b1;
    end
end

assign C = result;
assign valid = valid_reg & ready;

endmodule
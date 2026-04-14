module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input load,
    input clk,
    input S,
    input areset,
    output reg [3:0] Q
);reg [3:0] shift_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 4'b0;
    end else if (load) begin
        shift_reg <= {D,C,B,A};
    end else begin
        shift_reg <= {shift_reg[2:0], 1'b0};
    end
end

always @(*) begin
    if (S) begin
        Q <= {B,A};
    end else begin
        Q <= shift_reg;
    end
end

endmodule
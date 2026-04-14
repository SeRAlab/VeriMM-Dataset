module top_module(
    input clk,
    input reset,
    input [3:0] D,
    input SI,
    output reg [3:0] twos_comp,
    output reg SO
);reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {shift_reg[2:0], SI};
        if (D != 4'b0000) begin
            shift_reg <= D;
        end
    end
end

assign SO = shift_reg[0];

always @* begin
    if (shift_reg[3] == 1) begin
        twos_comp = ~(shift_reg[2:0]) + 1;
    end else begin
        twos_comp = shift_reg[2:0];
    end
end

endmodule
module top_module(
    input clk,
    input [3:0] in,
    input load,
    output reg [3:0] out,
    output reg valid
);reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= in;
            valid <= 1'b1;
        end else begin
            shift_reg <= {shift_reg[2:0], 1'b0};
            valid <= 1'b1;
        end
    end

    assign out = shift_reg;

endmodule
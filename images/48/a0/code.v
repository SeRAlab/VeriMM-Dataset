module top_module(
    input clk,
    input load,
    input ena,
    input [11:0] data,
    output reg q);

    reg [11:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
        end else if (ena) begin
            q <= shift_reg[11];
            shift_reg <= shift_reg << 1;
        end
    end

endmodule
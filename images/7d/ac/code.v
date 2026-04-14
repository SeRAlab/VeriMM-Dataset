module top_module(
    input [WIDTH-1:0] din,
    input clk,
    input rst,
    input start,
    output reg clk_sr,
    output reg [WIDTH-1:0] din_sr,
    output reg load_sr
    );parameter WIDTH=170;

reg [WIDTH-1:0] shift_reg;

always @(posedge clk_sr) begin
    if (load_sr) begin
        shift_reg <= din;
    end else if (!rst) begin
        shift_reg <= {WIDTH{1'b0}};
    end else begin
        shift_reg <= {shift_reg[WIDTH-2:0], 1'b0};
    end
end

always @(posedge clk) begin
    clk_sr <= start;
end

assign din_sr = shift_reg[WIDTH-1:0];

always @(posedge clk) begin
    if (start) begin
        load_sr <= 1'b1;
    end else begin
        load_sr <= 1'b0;
    end
end

endmodule
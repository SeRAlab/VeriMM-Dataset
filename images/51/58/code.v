module top_module(
    input wire clk,
    input wire rst,
    input wire [31:0] in,
    output wire [31:0] out
);reg [31:0] counter_reg = 0;

always @(posedge clk) begin
    if (rst) begin
        counter_reg <= 0;
    end else begin
        if (counter_reg + in > 2**32-1) begin
            counter_reg <= 2**32-1;
        end else begin
            counter_reg <= counter_reg + in;
        end
    end
end

assign out = counter_reg;

endmodule
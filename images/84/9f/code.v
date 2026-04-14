module top_module(
    input clk,
    input reset,
    output reg [3:0] bit_0,
    output reg [3:0] bit_1,
    output reg [3:0] bit_2,
    output reg [3:0] bit_3
);reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
    end else begin
        counter <= {counter[2:0], counter[3]};
    end
end

assign bit_0 = counter[0];
assign bit_1 = counter[1];
assign bit_2 = counter[2];
assign bit_3 = counter[3];

endmodule
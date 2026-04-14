module top_module(
    input clk,
    input reset,
    input async_reset,
    input a,
    input b,
    output reg out,
    output reg [3:0] q
);reg [3:0] counter;
reg xor_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 4'b0000;
        xor_out <= 1'b0;
    end else if (counter == 4'b0111) begin
        counter <= 4'b0000;
        xor_out <= a ^ b;
    end else begin
        counter <= counter + 1;
    end
end

always @(posedge clk) begin
    out <= xor_out;
end

endmodule
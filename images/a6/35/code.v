module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [3:0] a,
    input [3:0] b,
    input select, // Select input to choose between adder and register
    output reg [7:0] q // 8-bit output from the active module
);reg [3:0] sum;

always @ (posedge clk) begin
    if (reset) begin
        sum <= 4'b0000;
        q <= 8'b00000000;
    end else begin
        if (select) begin
            q <= sum;
        end else begin
            sum <= a + b;
            q <= sum;
        end
    end
end

endmodule
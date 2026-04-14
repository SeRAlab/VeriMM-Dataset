module top_module(
    input clk,     // Added clock input
    input a, 
    input b,
    output reg out
);reg pipe1_out;
reg pipe2_out;

always @ (posedge clk) begin
    pipe1_out <= a & b;
end

always @ (posedge clk) begin
    pipe2_out <= pipe1_out;
end

always @ (posedge clk) begin
    out <= pipe2_out;
end

endmodule
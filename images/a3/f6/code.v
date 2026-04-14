module top_module(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);reg [7:0] pipe1, pipe2, pipe3;

always @(posedge clk) begin
    pipe1 <= in;
end

always @(posedge clk) begin
    pipe2 <= pipe1;
end

always @(posedge clk) begin
    pipe3 <= pipe2;
end

assign anyedge = (pipe1 ^ pipe2) & pipe2 & (pipe2 ^ pipe3);

endmodule
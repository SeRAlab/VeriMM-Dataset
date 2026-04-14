module top_module(
    input clk,
    input [3:0] in,
    output reg [3:0] out  // Change to output reg to allow assignment in always block
);reg [3:0] prev_in;
reg [3:0] curr_in;

always @(posedge clk) begin
    prev_in <= curr_in;
    curr_in <= in;
end

always @(posedge clk) begin
    if (curr_in != prev_in) begin
        out <= prev_in;  // Now valid as out is declared as reg
    end
end

endmodule
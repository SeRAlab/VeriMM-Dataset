module top_module(
    input clk,
    input [15:0] in,
    output [3:0] out
);reg [15:0] prev_in;
reg [3:0] count;

always @(posedge clk) begin
    if (in[0] && !prev_in[0]) begin
        count <= count + 1;
    end
    if (in[1] && !prev_in[1]) begin
        count <= count + 1;
    end
    if (in[2] && !prev_in[2]) begin
        count <= count + 1;
    end
    if (in[3] && !prev_in[3]) begin
        count <= count + 1;
    end
    prev_in <= in;
end

assign out = count;

endmodule
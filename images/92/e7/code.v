module top_module(
    input wire in,
    output reg out0,
    output reg out1,
    output reg out2,
    output reg out3,
    output reg out
);reg [1:0] counter;
reg [3:0] bits;

always @(posedge in)
begin
    counter <= counter + 1;
    bits[counter[1:0]] <= in;
    out0 <= bits[0];
    out1 <= bits[1];
    out2 <= bits[2];
    out3 <= bits[3];
    out <= {out3, out2, out1, out0};
end

endmodule
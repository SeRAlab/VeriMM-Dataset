module top_module(
    input clk,
    input [7:0] d,
    input [2:0] select,
    output [7:0] q
);reg [7:0] shift_register [0:7];
integer i;

always @(posedge clk) begin
    for (i = 0; i < 8; i = i + 1) begin
        if (i == 0)
            shift_register[i] <= d;
        else
            shift_register[i] <= shift_register[i - 1];
    end
end

assign q = shift_register[select];

endmodule
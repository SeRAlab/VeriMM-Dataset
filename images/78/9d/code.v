module top_module(
    input clk,
    input [2:0] select,
    output reg [7:0] out
);reg [7:0] pipeline1, pipeline2;

always @(posedge clk) begin
    pipeline1 <= pipeline2;
    pipeline2 <= {~select[2], ~select[1], ~select[0], ~select[2], ~select[1], select[0], ~select[2], select[1], ~select[0]};
end

assign out = pipeline1;

endmodule
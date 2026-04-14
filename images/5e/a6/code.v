module top_module(
    input [3:0] in,
    input shift_dir,
    input clk,
    output reg [3:0] out
);reg [3:0] pipeline [0:1];

always @(posedge clk) begin
    pipeline[0] <= in;
    if (shift_dir == 0) begin
        pipeline[1] <= pipeline[0] << 1;
    end else begin
        pipeline[1] <= pipeline[0] >> 1;
    end
end

assign out = pipeline[1];

endmodule
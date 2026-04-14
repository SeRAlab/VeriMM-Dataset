module top_module(
    input clk,
    input serial_in,
    input reset,
    output reg [3:0] parallel_out
);reg [3:0] pipeline [0:2];

always @(posedge clk) begin
    pipeline[0] <= serial_in;
    pipeline[1] <= pipeline[0];
    pipeline[2] <= pipeline[1];
end

always @(negedge clk) begin
    if (!reset) begin
        parallel_out <= 4'b0;
    end else begin
        parallel_out <= pipeline[2];
    end
end

endmodule
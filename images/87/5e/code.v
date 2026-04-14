module top_module(
    input clk,
    input parallel_load,
    input serial_in,
    output serial_out,
    input [3:0] data_in
);reg [3:0] pipeline [0:2];

always @(posedge clk) begin
    pipeline[0] <= parallel_load ? data_in : pipeline[0];
    pipeline[1] <= pipeline[0];
    pipeline[2] <= pipeline[1];
end

assign serial_out = pipeline[2][0];

always @(posedge clk) begin
    if (!parallel_load) begin
        pipeline[0][0] <= serial_in;
        pipeline[0][1] <= pipeline[1][0];
        pipeline[0][2] <= pipeline[2][1];
        pipeline[0][3] <= pipeline[2][2];
    end
end

endmodule
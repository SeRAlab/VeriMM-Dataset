module top_module(
    input scan_in,
    output scan_out,
    input clk,
    input reset,
    input data_in,
    output data_out
);reg [4:0] chain;

always @(posedge clk) begin
    if (reset) begin
        chain <= 5'b00000;
    end else begin
        chain <= {chain[3:0], data_in};
    end
end

assign data_out = chain[4];

always @(posedge clk) begin
    if (scan_in) begin
        chain <= {scan_in, chain[4:1]};
    end
end

assign scan_out = chain[0];

endmodule
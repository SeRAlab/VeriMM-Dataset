module top_module(
    input clk, reset,
    input [39:0] stream_in_data,
    input stream_in_startofpacket,
    input stream_in_endofpacket,
    input stream_in_valid,
    output stream_in_ready,
    input stream_out_ready,
    output reg [39:0] stream_out_data,
    output reg stream_out_startofpacket,
    output reg stream_out_endofpacket,
    output reg stream_out_valid
);parameter COLOR = 30'd0;
parameter ALPHA = 10'd0;

reg [39:0] converted_data;

assign stream_in_ready = stream_out_ready | ~stream_out_valid;

always @(*) begin
    if (stream_in_data[30:0] == COLOR) begin
        converted_data[39:31] = ALPHA;
        converted_data[30:0] = stream_in_data[30:0];
    end else begin
        converted_data = stream_in_data;
    end
end

always @(posedge clk) begin
    if (reset) begin
        stream_out_data <= 'b0;
        stream_out_startofpacket <= 1'b0;
        stream_out_endofpacket <= 1'b0;
        stream_out_valid <= 1'b0;
    end else if (stream_out_ready | ~stream_out_valid) begin
        stream_out_data <= converted_data;
        stream_out_startofpacket <= stream_in_startofpacket;
        stream_out_endofpacket <= stream_in_endofpacket;
        stream_out_valid <= stream_in_valid;
    end
end

endmodule
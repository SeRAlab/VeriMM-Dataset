module simple_stream_cipher (
    input wire [31:0] data_in,
    input wire [31:0] key,
    input wire start,
    output reg [31:0] data_out
);

always @(posedge start) begin
    data_out <= data_in ^ key;
end

endmodule
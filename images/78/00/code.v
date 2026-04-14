module top_module(
    input clk,            // Added clk input declaration
    input [15:0] data_in,
    output reg [31:0] comp_concat_out
);reg [7:0] data_out1;
reg [23:0] data_out2;

always @ (posedge clk) begin
    data_out1 <= data_in[7:0];
end

always @ (posedge clk) begin
    data_out2 <= ~data_in[15:8];
end

always @ (posedge clk) begin
    comp_concat_out <= {data_out1, data_out2};
end

endmodule
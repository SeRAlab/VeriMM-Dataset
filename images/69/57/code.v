module top_module(
    input clk,
    input rst,
    // AXI input
    input [63:0] input_axis_tdata,
    input [7:0] input_axis_tkeep,
    input input_axis_tvalid,
    output input_axis_tready,
    input input_axis_tlast,
    input input_axis_tuser,
    // AXI output
    output reg [63:0] output_axis_tdata,
    output reg [7:0] output_axis_tkeep,
    output reg output_axis_tvalid,
    input output_axis_tready,
    output reg output_axis_tlast,
    output reg output_axis_tuser
);reg [63:0] register_value;

always @(posedge clk) begin
    if (rst) begin
        register_value <= 64'd0;
        output_axis_tdata <= 64'd0;
        output_axis_tkeep <= 8'd0;
        output_axis_tvalid <= 1'b0;
        output_axis_tlast <= 1'b0;
        output_axis_tuser <= 1'b0;
    end else begin
        if (input_axis_tvalid) begin
            register_value <= input_axis_tdata;
        end
        output_axis_tdata <= register_value;
        output_axis_tkeep <= input_axis_tkeep;
        output_axis_tvalid <= input_axis_tvalid;
        output_axis_tlast <= input_axis_tlast;
        output_axis_tuser <= input_axis_tuser;
    end
end

assign input_axis_tready = output_axis_tready;

endmodule
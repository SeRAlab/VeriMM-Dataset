module top_module(
    input clk,            // Added the clock input
    input [15:0] data_in,
    input write_en,
    input read_en,
    output [15:0] data_out
);reg [31:0] reg_data;

always @(posedge clk) begin
    if (write_en) begin
        reg_data <= {16'b0, data_in};
    end
end

assign data_out = read_en ? reg_data[31:16] : 16'b0;

endmodule
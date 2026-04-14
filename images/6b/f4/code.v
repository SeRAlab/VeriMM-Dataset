module top_module(
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    input shift,
    input serial_in,
    output reg [7:0] data_out
);reg [7:0] reg_data;

always @(posedge clk) begin
    if (reset) begin
        reg_data <= 8'b0;
    end else if (load) begin
        reg_data <= data_in;
    end else if (shift) begin
        reg_data <= {reg_data[6:0], serial_in};
    end
end

assign data_out = reg_data;

endmodule
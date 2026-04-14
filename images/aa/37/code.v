module top_module(
    input clk,
    input reset,
    input data_in,
    output reg data_out
);reg stored_data;

always @(posedge clk) begin
    if (reset) begin
        stored_data <= 1'b0;
    end else begin
        stored_data <= data_in;
    end
end

assign data_out = stored_data;

endmodule
module top_module(
    input wire clk,       // Added clk input
    input wire data,
    output wire to_pad
);reg delayed_data;

always @(posedge clk) begin
    delayed_data <= data;
end

assign to_pad = delayed_data;

endmodule
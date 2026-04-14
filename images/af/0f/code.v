module top_module(
    input clk,
    input reset,            // Synchronous reset
    input [7:0] data_in,
    output [7:0] data_out
);reg [7:0] shift_reg [0:1];  // Two stages of the pipeline

always @(posedge clk) begin
    if (reset) begin
        shift_reg[0] <= 8'b0;
        shift_reg[1] <= 8'b0;
    end
    else begin
        shift_reg[0] <= data_in;
        shift_reg[1] <= shift_reg[0];
    end
end

assign data_out = shift_reg[1];

endmodule
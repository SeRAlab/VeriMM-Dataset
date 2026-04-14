module top_module(
    input clk,
    input reset,
    input [11:0] address,
    input [15:0] data_in,
    input write_en,
    output reg [15:0] data_out
);reg [15:0] memory[0:4095];

always @(posedge clk) begin
    if (reset) begin
        data_out <= 16'h0000;
    end else begin
        if (write_en) begin
            memory[address] <= data_in;
        end else begin
            data_out <= memory[address];
        end
    end
end

endmodule
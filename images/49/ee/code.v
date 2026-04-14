module top_module(
    input clk,
    input reset_n,
    input [31:0] data_in,
    input write_en,
    input [14:0] address,
    output reg [31:0] data_out
);reg [31:0] memory [0:1023];

always @(posedge clk) begin
    if (!reset_n) begin
        data_out <= 0;
    end else if (write_en) begin
        memory[address] <= data_in;
    end else begin
        data_out <= memory[address];
    end
end

endmodule
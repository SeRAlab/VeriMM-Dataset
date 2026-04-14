module top_module(
    input clk,
    input reset,
    input [7:0] data_in,
    input enable,
    output reg [7:0] data_out, // Changed from wire to reg
    output reg [3:0] count
);always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            data_out <= 0;
        end else if (enable) begin
            data_out <= data_in & 8'h0F;
            count <= count + 1;
        end
    end
    
endmodule
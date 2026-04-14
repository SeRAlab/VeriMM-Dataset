module top_module(
    input wire clk,
    input wire resetn,
    input wire write_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            data_out <= 8'h00;
        end else if (write_en) begin
            data_out <= data_in;
        end
    end

endmodule
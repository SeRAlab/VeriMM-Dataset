module top_module(
    input wire reset,
    input wire wenb,
    input wire [7:0] in_data,
    input wire clk,
    output reg [7:0] out_data
);always @(posedge clk or negedge reset) begin
        if (~reset) begin
            out_data <= 8'h00;
        end else begin
            if (wenb) begin
                out_data <= in_data;
            end
        end
    end

endmodule
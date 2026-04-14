module top_module(
    input load,
    input clear,
    input clk,
    input [3:0] data_in,
    output reg [3:0] data_out
);always @(posedge clk) begin
        if (clear) begin
            data_out <= 4'b0000;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {data_out[2:0], data_out[3]};
        end
    end

endmodule
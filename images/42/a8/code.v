module top_module(
    input clk,
    input [3:0] data_in,
    input load,
    output reg [3:0] data_out
);always @(posedge clk) begin
        if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {data_out[2:0], data_out[3]};
        end
    end

endmodule
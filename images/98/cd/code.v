module top_module(
    input clk,
    input data_in,
    input shift_left,
    input load,
    output reg [2:0] data_out
);always @(posedge clk) begin
        if (load) begin
            data_out <= data_in;
        end else if (shift_left) begin
            data_out <= {data_out[1:0], data_out[2]};
        end
    end

endmodule
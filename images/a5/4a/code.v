module top_module(
    input clk,
    input rst_n,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out <= 8'h00;
        end
        else begin
            if (load) begin
                data_out <= data_in;
            end
            else begin
                data_out <= {data_out[6:0], 1'b0};
            end
        end
    end

endmodule
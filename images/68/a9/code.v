module top_module(
    input clk,
    input load,
    input reset,
    input [1:0] data_in,
    output reg [1:0] data_out
);always @(posedge clk or negedge reset) begin
        if(!reset) begin
            data_out <= 2'b0;
        end else if(load) begin
            data_out <= data_in;
        end else begin
            data_out <= data_out + 2'b1;
        end
    end

endmodule
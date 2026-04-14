module top_module(
    input clk,
    input rst,
    input load,
    input [2:0] data_in,
    output reg [2:0] count_out
);always @(posedge clk or negedge rst) begin
    if(!rst) begin
        count_out <= 3'b0;
    end else if(load) begin
        count_out <= data_in;
    end else begin
        count_out <= count_out + 1;
    end
end

endmodule
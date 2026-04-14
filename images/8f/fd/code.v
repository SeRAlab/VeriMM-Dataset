module top_module(
    input clk,
    input data_in,
    input reset_n,
    output reg data_out
);reg data_in_d1;
reg data_in_d2;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        data_in_d1 <= 0;
        data_in_d2 <= 0;
        data_out <= 0;
    end else begin
        data_in_d1 <= data_in;
        data_in_d2 <= data_in_d1;
        data_out <= data_in_d2;
    end
end

endmodule
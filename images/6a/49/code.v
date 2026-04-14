module top_module(
    input clk,
    input reset,
    input data_in,
    input enable_1,
    input enable_2,
    output reg data_out
);always @(posedge clk or negedge reset) begin
    if(!reset) begin
        data_out <= 1'b0;
    end else if(enable_1 && !enable_2) begin
        data_out <= data_in;
    end else if(!enable_1 && enable_2) begin
        data_out <= data_out;
    end else if(enable_1 && enable_2) begin
        data_out <= 1'b0;
    end
end

endmodule
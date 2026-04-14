module top_module(
    input clk, 
    input rst, 
    input data, 
    output reg out
);reg [2:0] pipeline;

always @(posedge clk) begin
    if (rst) begin
        pipeline <= 3'b0;
        out <= 1'b0;
    end else begin
        pipeline[2] <= pipeline[1];
        pipeline[1] <= pipeline[0];
        pipeline[0] <= data;
        out <= pipeline[2];
    end
end

endmodule
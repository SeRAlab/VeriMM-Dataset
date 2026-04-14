module top_module(
    input clk,
    input rst,
    input [3:0] parameterIn,
    output reg [7:0] outputSignal
);always @(posedge clk) begin
    if(rst) begin
        outputSignal <= 8'b0;
    end else begin
        outputSignal <= {4'b0, parameterIn};
    end
end

endmodule
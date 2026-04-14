module top_module(
    input clk,
    input reset,
    input [7:0] data_in1,
    input [7:0] data_in2,
    input [1:0] ctrl,
    output reg [7:0] result
);always @(posedge clk) begin
    if(reset) begin
        result <= 8'b0;
    end
    else begin
        case(ctrl)
            2'b00: result <= data_in1 + data_in2;
            2'b01: result <= data_in1 - data_in2;
            2'b10: result <= data_in1 * data_in2;
            2'b11: result <= data_in1 / data_in2;
        endcase
    end
end

endmodule
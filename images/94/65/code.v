module top_module(input CLK, input reset, input enable, input [7:0] input_num, output reg [15:0] output_num);always @(posedge CLK) begin
    if (reset) begin
        output_num <= 16'd0;
    end else if (enable) begin
        output_num <= {input_num, 8'd0} * 2;
    end
end

endmodule
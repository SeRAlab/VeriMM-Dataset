module top_module(input clk, input reset, input enable, input in, output reg [4-1:0] out);always @(posedge clk) begin
        if(reset) begin
            out <= 4'b0;
        end else if(enable) begin
            out <= out + 1;
        end
    end
endmodule
module top_module(input clk, input [3:0] din, output reg [3:0] dout);reg [3:0] reg_data;

    always @(posedge clk) begin
        reg_data <= din;
    end

    assign dout = reg_data;
endmodule
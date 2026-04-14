module top_module(
    input clk,
    input LOAD,
    input RESET,
    input [1:0] DATA,
    output reg [1:0] Q
);always @(posedge clk) begin
        if (RESET) begin
            Q <= 2'b00;
        end
        else if (LOAD) begin
            Q <= DATA;
        end
        else begin
            Q <= Q + 2'b01;
        end
    end

endmodule
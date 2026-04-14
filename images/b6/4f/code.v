module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] data_out
);reg [3:0] reg1, reg2, reg3, reg4;

always @(posedge clk) begin
    if (reset) begin
        reg1 <= 4'b0;
        reg2 <= 4'b0;
        reg3 <= 4'b0;
        reg4 <= 4'b0;
    end else begin
        reg1 <= load ? data_in : reg1;
        reg2 <= reg1;
        reg3 <= reg2;
        reg4 <= reg3;
    end
end

assign data_out = reg4;

endmodule
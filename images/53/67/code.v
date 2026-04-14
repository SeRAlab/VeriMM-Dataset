module top_module(
    input clk,
    input dir,
    input [2:0] in,
    output reg [2:0] out
);reg [2:0] reg1, reg2, reg3;

always @(posedge clk) begin
    if (dir == 1'b0) begin // shift right
        reg3 <= reg2;
        reg2 <= reg1;
        reg1 <= in;
    end else begin // shift left
        reg1 <= reg2;
        reg2 <= reg3;
        reg3 <= in;
    end
end

assign out = (dir == 1'b0) ? reg1 : reg3;

endmodule
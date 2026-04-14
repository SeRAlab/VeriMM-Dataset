module top_module(
  input clk,
  input reset,
  input [31:0] in,
  input ld,
  output [31:0] out
  );reg [31:0] cnt = 32'h00000000;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            cnt = 32'h00000000;
        end else if (ld == 1) begin
            cnt <= in;
        end else begin
            cnt <= cnt + 4;
        end
    end
    assign out = cnt;

endmodule
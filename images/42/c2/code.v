module top_module(
    input clk,
    input reset,
    input control,
    input [3:0] A,
    input [1:0] B,
    output [3:0] Q,
    output COUT
);reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else if (control) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

assign COUT = (B == 2'b11) ? ((control) ? (count == 4'b1111) : (count == 4'b0000)) : 1'b0;

assign Q = (B == 2'b00) ? A :
          (B == 2'b01) ? {A[2:0], COUT} :
          (B == 2'b10) ? {COUT, A[3:1]} :
          (control) ? count : (15 - count);

endmodule
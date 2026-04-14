module top_module(
    input clk,
    input a,
    input b,
    input select,
    output reg out
);reg xor1_out, xor2_out;

always @(posedge clk) begin
    case (select)
        1'b0: xor1_out <= a ^ b;
        1'b1: xor2_out <= a ^ b;
    endcase
end

always @(posedge clk) begin
    if (select == 1'b0) begin
        out <= xor1_out;
    end else begin
        out <= xor2_out;
    end
end

endmodule
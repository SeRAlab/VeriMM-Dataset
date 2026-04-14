module top_module(
    input clk,
    input [7:0] A,
    input L,
    output reg [7:0] B  // Change output to reg type
);reg [7:0] reg1, reg2, reg3, reg4;

always @(posedge clk) begin
    if (L) begin
        reg1 <= A;
        reg2 <= reg1;
        reg3 <= reg2;
        reg4 <= reg3;
    end else begin
        reg1 <= reg2;
        reg2 <= reg3;
        reg3 <= reg4;
        reg4 <= 0;
    end
    B <= reg4;  // Move B assignment outside the if/else statement
end

endmodule
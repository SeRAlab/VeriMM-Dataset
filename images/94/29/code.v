module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);reg [99:0] reg1, reg2, reg3, reg4, reg5;

always @(posedge clk) begin
    if (load) begin
        reg1 <= data;
        reg2 <= 0;
        reg3 <= 0;
        reg4 <= 0;
        reg5 <= 0;
    end
    else begin
        reg1 <= reg1;
        reg2 <= reg1;
        reg3 <= reg2;
        reg4 <= reg3;
        reg5 <= reg4;
    end
end

always @(*) begin
    case (ena)
        2'b00: q = reg1;
        2'b01: q = reg2;
        2'b10: q = reg4;
        2'b11: q = reg5;
    endcase
end

endmodule
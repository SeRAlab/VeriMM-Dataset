module addsub4bit(
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    input C0,
    input C1,
    output reg [3:0] result
);

always @(posedge clk) begin
    if (reset) begin
        result <= 4'b0;
    end else begin
        case ({C1, C0})
            2'b00: result <= A + B;
            2'b01: result <= A + B + 1;
            2'b10: result <= A - B;
            2'b11: result <= A - B - 1;
        endcase
    end
end

endmodule
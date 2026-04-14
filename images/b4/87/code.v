module top_module(
    input [1:0] sel,
    input enable,
    output reg [15:0] out
);reg [1:0] priority_sel;

always @(*) begin
    if (enable) begin
        casez(sel)
            2'b00: priority_sel = 2'b00;
            2'b01: priority_sel = 2'b01;
            2'b10: priority_sel = 2'b10;
            2'b11: priority_sel = 2'b11;
        endcase
    end else begin
        priority_sel = 2'b00;
    end
end

always @(priority_sel) begin
    case (priority_sel)
        2'b00: out = 16'b0000000000000001;
        2'b01: out = 16'b0000000000000010;
        2'b10: out = 16'b0000000000000100;
        2'b11: out = 16'b0000000000001000;
    endcase
end

endmodule
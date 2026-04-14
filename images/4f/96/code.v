module top_module(
    input clk,
    input [7:0] in1,
    input [7:0] in2,
    input reset,
    input select,
    output [7:0] out
);reg [7:0] dff1, dff2;
reg enable_dff1, enable_dff2;

always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
        dff1 <= 8'b0;
        dff2 <= 8'b0;
        enable_dff1 <= 0;
        enable_dff2 <= 0;
    end else begin
        if (enable_dff1 == 1) begin
            dff1 <= in1 + in2;
            enable_dff1 <= 0;
            enable_dff2 <= 1;
        end else if (enable_dff2 == 1) begin
            dff2 <= in1 + in2;
            enable_dff1 <= 1;
            enable_dff2 <= 0;
        end
    end
end

assign out = select ? dff2 : dff1;

endmodule
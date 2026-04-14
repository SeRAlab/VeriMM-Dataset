module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input clk,         // Added the clock input
    output reg [1:0] out
);reg [3:0] reg_in0;
reg [3:0] reg_in1;

always @(posedge clk) begin
    reg_in0 <= in0;
    reg_in1 <= in1;
end

always @(posedge clk) begin
    if(reg_in0 < reg_in1) begin
        out <= 2'b00;     // Directly assign to output `out`
    end else if(reg_in0 == reg_in1) begin
        out <= 2'b01;     // Directly assign to output `out`
    end else begin
        out <= 2'b10;     // Directly assign to output `out`
    end
end

endmodule
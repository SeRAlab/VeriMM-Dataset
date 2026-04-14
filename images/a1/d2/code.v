module top_module(
    input wire clk, // Added clock input
    input wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);reg [2:0] reg1;
reg [2:0] reg2;
reg [2:0] reg3;

assign outv = reg3;
assign o2 = reg3[2];
assign o1 = reg2[1];
assign o0 = reg1[0];

always @(posedge clk) begin
    reg1 <= vec;
end

always @(posedge clk) begin
    reg2 <= reg1;
end

always @(posedge clk) begin
    reg3 <= reg2;
end

endmodule
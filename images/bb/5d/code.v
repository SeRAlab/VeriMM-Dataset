module top_module(
    input clk,
    input areset, // async active-high reset to zero
    input load,
    input ena,
    input [2:0] d3, // 3-bit input for the 3-bit shift register
    input [3:0] d4, // 4-bit input for the 4-bit shift register
    output reg [6:0] q // 7-bit output from the functional module
);// 3-bit shift register using D flip-flops and multiplexers
reg [2:0] sr3;
always @(posedge clk) begin
    if (areset) begin
        sr3 <= 3'b0;
    end else begin
        sr3 <= {sr3[1:0], d3};
    end
end

reg [3:0] sr4;
always @(posedge clk) begin
    if (areset) begin
        sr4 <= 4'b0;
    end else if (load) begin
        sr4 <= d4;
    end else if (ena) begin
        sr4 <= {sr4[2:0], sr4[3]};
    end
end

assign q = sr3[0] + sr4;

endmodule
module top_module(
    input wire clk,
    input wire [3:0] reset,
    input wire [3:0] load,
    input wire [3:0] count,
    output reg [3:0] out
);always @(posedge clk) begin
    if(reset == 4'b1111) begin
        out <= 4'b0000;
    end else if(load != 4'b0000) begin
        out <= count;
    end else begin
        out <= out + 4'b0001;
    end
end

endmodule
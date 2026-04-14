module reg8bit (
    input [7:0] data,
    input clk,
    input load,
    output reg [7:0] q
);always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
end

endmodule
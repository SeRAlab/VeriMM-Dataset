module binary_down_counter(
    input clk,
    input reset,
    
    output reg [3:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 4'b1111;
    end else begin
        q <= q - 1;
    end
end

endmodule
module gray_counter(
    input clk,
    input reset,
    
    output reg [2:0] q
);

reg [2:0] binary_count;

always @(posedge clk) begin
    if (reset) begin
        binary_count <= 3'b000;
        q <= 3'b000;
    end else begin
        binary_count <= binary_count + 1;
        q <= binary_count ^ (binary_count >> 1);
    end
end

endmodule
module top_module(
    input clk,
    input rst,
    input en,
    output reg [N-1:0] count
);parameter N = 4; // Change N to set the number of bits in the counter

always @(posedge clk) begin
    if (rst) begin
        count <= 0;
    end else if (en) begin
        if (count == (2**N - 1)) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule
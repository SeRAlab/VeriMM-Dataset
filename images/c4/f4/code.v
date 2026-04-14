module synchronous_counter(
    input clk, // clock input
    input reset, // reset input
    output reg [3:0] count // 4-bit output port
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000; // reset count to 0
    end else begin
        if (count == 4'b1001) begin
            count <= 4'b0000; // reset count to 0 when it reaches 9
        end else begin
            count <= count + 1; // increment count by 1
        end
    end
end

endmodule
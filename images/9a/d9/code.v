module binary_counter (
    input clk,
    input reset,
    output reg [1:0] count
);

always @(negedge clk or posedge reset) begin
    if (reset)
        count <= 2'b00;
    else
        count <= count + 1;
end

endmodule
module johnson_counter_8bit(
    input clk,
    input reset,
    output reg [7:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 8'b00000000;
    else
        count <= {count[6:0], ~count[7]};
end

endmodule
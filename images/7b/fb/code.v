module johnson_counter_4bit(
    input  clk,
    output reg [3:0] count
);

always @(posedge clk) begin
    count <= {count[2:0], ~count[3]};
end

endmodule
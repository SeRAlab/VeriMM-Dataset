module binary_counter(
    input        clk,
    input        rst_n,
    output reg [3:0] count
);

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 4'd0;
    else
        count <= count + 1;
end

endmodule
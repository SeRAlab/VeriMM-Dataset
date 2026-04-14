module ring_counter_3bit(
    input                 clk,
    input                 rst_n,
    
    output reg  [2:0]     count
);

// Ring counter implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 3'b001;
    else
        count <= {count[1:0], count[2]};
end

endmodule
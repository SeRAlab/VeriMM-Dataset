module ring_counter_8bit(
    input clk,
    input reset,
    output reg [7:0] count
);
    always @(posedge clk) begin
        if (reset)
            count <= 8'b00000001;
        else
            count <= {count[6:0], count[7]};
    end
endmodule
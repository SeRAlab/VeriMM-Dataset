module johnson_counter(
    input clk,
    input reset,
    input enable,
    output reg [9:0] count
);

always @(posedge clk or posedge reset)
    if (reset) begin
        count <= 10'b0000000000; // Reset count to 0
    end else if (enable) begin
        count <= {~count[0], count[9:1]}; // Johnson counter sequence
    end

endmodule
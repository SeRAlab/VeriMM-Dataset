module top_module(
    input [7:0] in1,
    input [7:0] in2,
    input reset,
    output reg [7:0] sum, // Change to reg type
    output reg overflow    // Change to reg type
);reg [8:0] temp_sum;

always @(*) begin
    if (reset) begin
        temp_sum = 0;
        overflow = 0;
    end else begin
        temp_sum = {1'b0, in1} + {1'b0, in2};
        overflow = temp_sum[8];
    end
end

assign sum = temp_sum[7:0];

endmodule
module top_module(
    input signed [15:0] num_in,
    output reg [15:0] num_out
);always @(*) begin
        if (num_in < 0) begin
            num_out = -num_in;
        end else begin
            num_out = num_in;
        end
    end

endmodule
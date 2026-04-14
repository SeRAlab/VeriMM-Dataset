module shift_register (
    input clk,
    input reset_n,
    input load,
    input [4:0] parallel_in,
    output reg [4:0] out
);always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        out <= 5'b00000;
    end else if (load) begin
        out <= parallel_in;
    end else begin
        out <= {1'b0, out[4:1]};
    end
end

endmodule
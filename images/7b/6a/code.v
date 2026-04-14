module shift_register(
    input clk,
    input reset,
    input load,
    input shift,
    input [7:0] data_in,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else if (load) begin
            q <= data_in;
        end else if (shift) begin
            q <= {q[6:0], 1'b0};
        end
    end

endmodule
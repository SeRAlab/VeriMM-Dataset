module shift_register (
    input clk,
    input load,
    input [7:0] parallel_in,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= parallel_in;
        end else begin
            q <= {q[6:0], 1'b0};
        end
    end
endmodule
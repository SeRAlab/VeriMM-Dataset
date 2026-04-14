module bidirectional_shift_register (
    input clk,
    input load,
    input dir,
    input [7:0] parallel_in,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= parallel_in;
        end else if (dir) begin
            q <= {q[6:0], 1'b0}; // shift left
        end else begin
            q <= {1'b0, q[7:1]}; // shift right
        end
    end
endmodule
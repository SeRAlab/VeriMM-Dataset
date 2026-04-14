module top_module (
    input clk,
    input load,
    input [3:0] parallel_in,
    input serial_in,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= parallel_in;
        end else begin
            q <= {q[2:0], serial_in};
        end
    end

endmodule
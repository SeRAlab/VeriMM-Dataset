module shift_register_8bit (
    input [7:0] d,
    input load,
    input clk,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= d;
        end else begin
            q <= {1'b0, q[7:1]};
        end
    end

endmodule
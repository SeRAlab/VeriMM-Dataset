module shift_register (
    input clk,
    input load,
    input [3:0] data,
    output reg [3:0] q
);

    // Shift register logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= {q[2:0], 1'b0};
        end
    end

endmodule